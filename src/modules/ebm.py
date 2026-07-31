from numpy import exp, log
from math import pi

STEFAN_BOLTZMANN = 5.6704e-8 # [W m^-2 K^-4] Constante de Stefan-Boltzmann
R = 6_371_000 # [m] - Raio da Terra
rho = 1.2 # [kg m^-3] - Densidade do ar
c = 1_000 # [J kg^-1 K^-1] - Calor especifico do ar

class EBM:
    """
    Classe que define um modelo climatico simples do tipo de balanco de energia (EBM).
    """

    def __init__(
        self, t0, T0, h_atm:float = 12_000, S0:float = 1_367,
        alpha:float = 0.3, epsilon:float = 0.6, radiative_forcing:bool = True,
        verbose:bool = False
    ):
        """
        Metodo de inicializacao da classe.

        t0: ano inicial - valor padroa: 1800 (planeta pre-industrial).
        h_atm: tamanho da atmosfera - valor padrao: 12 km.
        S0: constante solar - valor padrao: 1.367 Wm^-2.
        alpha: refletividade planetaria - valor padrao: 0.3.
        epsilon: emissividade planetaria - valor padrao: 0.6.
        radiative_forcing: se o forcamento radiativo deve ser incluido - valor padrao: sim.
        verbose: escrever logs no terminal? - valor padrao: nao.
        """

        self.t0 = t0
        self.T0 = T0
        self.h_atm = h_atm
        self.S0 = S0
        self.alpha = 0.3
        self.epsilon = epsilon
        self.radiative_forcing = radiative_forcing
        self.verbose = verbose

        if self.verbose:
            print(f"\nAno inicial: {self.t0} || Temperatura inicial: {self.kelvin_to_celsius(T0) :.2f} oC.")
            print(f"Informacoes da Atmosfera:\nh_atm={self.h_atm} m")
            print(f"Informacoes planetarias:\nS0={self.S0} Wm-2 | alpha = {self.alpha} | epsilon = {self.epsilon}")
            print(f"Incluir Forcamento Radiativo? {'Sim' if self.radiative_forcing else 'Nao'}\n")

    def ode(self, t:int, T:float):
        """
        Cria a EDO que representa o EBM no formato: f(t,T) = dT/dt.

        t: tempo em anos.
        T: temperatura em Kelvin.
        """

        norm_sun = self._sun_radiation(self.S0, self.alpha) / self._denominator(self.h_atm)
        norm_emission = self._earth_radiation(T, self.epsilon) / self._denominator(self.h_atm)

        if not self.radiative_forcing:
            return norm_sun - norm_emission

        norm_forcing = self._radiative_forcing(t) / self._denominator(self.h_atm)

        return norm_sun - norm_emission + norm_forcing

    @staticmethod
    def _denominator(h_atm:float = 12_000):
        """
        Constante que acompanha a derivada na equacao original.
        """
        return 4 * pi * (R ** 2) * h_atm * rho * c

    @staticmethod
    def _sun_radiation(S0, alpha:float = 0.3):
        """
        Efeito da radiacao solar, incluindo refletividade.
        """
        return pi * (R ** 2) * (1 - alpha) * S0

    @staticmethod
    def _earth_radiation(T:float, epsilon:float = 0.6):
        """
        Efeito da emissao terrestre.
        """
        return 4 * pi * (R ** 2) * epsilon * STEFAN_BOLTZMANN * (T**4)

    @staticmethod
    def CO2_conc(t:float):
        """
        Curva que representa a concentracao de CO2 na atmosfera por ano.
        Otimizada usando scipy.curve_fit.
        """
        return 283.122 + ( 7.559e-17 * exp(t * 0.021))

    @staticmethod
    def N2O_conc(t:float):
        """
        Curva que representa a concentracao de N2O na atmosfera por ano.
        Otimizada usando scipy.curve_fit.
        """
        return 263.248 + ( 6.569e-12 * exp(t * 0.015))

    def _radiative_forcing(self, t):
        """
        Efeito do forcamento radiativo.
        """
        a1 = -2.4e-7
        b1 = 7.2e-4
        c1 = -2.1e-4

        deltaC = self.CO2_conc(t) - self.CO2_conc(self.t0)
        Nbar = (self.N2O_conc(t) + self.N2O_conc(self.t0))/2

        return (a1*(deltaC**2) + b1*abs(deltaC) + c1*Nbar + 5.36) * log(self.CO2_conc(t)/self.CO2_conc(self.t0))

    @staticmethod
    def celsius_to_kelvin(t_celsius):
        """
        Funcao para converter temperatura em celsius para kelvin.
        """
        return t_celsius + 273.5

    @staticmethod
    def kelvin_to_celsius(t_kelvin):
        """
        Funcao para converter temperatura em kelvin para celsius.
        """
        return t_kelvin - 273.15
