
class RungeKutta:
    """
    Classe para solucao de funcoes usando um algoritmo da familia Runge-Kutta com 2a ou 4a ordem.
    Resolve uma EDO generica usando a ordem desejada e com parametros configuraveis.
    """

    def __init__(
        self, ode, timestep:float = 0.1, order: int = 4, max_iterations:int|None = None,
        verbose:bool = False
    ):
        """
        Inicializador da Classe.

        ode: funcao que representa a EDO ja na forma: dy/dx = f(x,y).
        timestep: tamanho de passo do iterador - valor padrao: 0.1.
        order: ordem do runge kutta utilizado, pode ser 2 ou 4 - valor padrao: 4.
        max_iterations: limitador de iteracoes para controle computacional.
        verbose: solucionar de forma verbosa? valor padrao: nao.
        """
        self.ode = ode
        self.order = order
        self.timestep = timestep
        self.verbose = verbose
        self.max_iterations = max_iterations
        self.iteration_data = list()

        if order not in (2,4):
            raise ValueError("Apenas Runge-Kuttas de 2a e 4a ordem sao aceitos.")

        if self.verbose:
            print(f"\nRunge-Kutta de Ordem {self.order}.")
            print(f"Tamanho de passo: {self.timestep}.\n")

    @staticmethod
    def calculate_k(f, x, y, h, order:int = 4) -> float:
        """
        Calcula os 'K's do metodo e ja resolve a media ponderada deles.
        """

        k1 = f(x, y)
        k2 = f(x + h/2, y + k1*(h/2))

        if order == 2:
            return (k1/3) + (2*k2)/3

        k3 = f(x + h/2, y + k2*(h/2))
        k4 = f(x + h, y + k3*h)

        return (k1 + 2*k2 + 2*k3 + k4)/6

    def solve(
        self, initial_values:tuple, x_max:int|None = None,
    ) -> float:
        """
        Soluciona a ODE numericamente.

        initial_values: tupla com os valores inicial, formato esperado: (x0, y0)
        x_max: valor maximo para x - condicao de parada.
        """
        x, y = initial_values

        _iter=1
        while x < x_max:

            k_contribution = self.calculate_k(
                self.ode, x, y, self.timestep, self.order
            )

            y += self.timestep*k_contribution
            x += self.timestep
            _iter += _iter
            self.iteration_data.append((x,y))

            #if (self.max_iterations is not None) and (_iter >= self.max_iterations):
            #    raise ValueError("Numero de iteracoes maximas atingida.")

        return y

    def export_iteration_data(self):
        if not self.iteration_data:
            raise ValueError("So e possivel exportar os dados apos a resolucao.")

        return self.iteration_data
