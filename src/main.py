from modules.ebm import EBM
from modules.rk import RungeKutta
from modules.data import plot_data, export_csv

from datetime import datetime as dt
import click

@click.command()
@click.argument("ano_inicial", default=1800)
@click.argument("temp_inicial", default=286.75)
@click.option("--ano-final", default = 2026, help="Ano para estimar a temperatura (ao deixar em branco, o ano atual e usado)")
@click.option("--timestep", default=0.1, help="Tamanho de passo")
@click.option("--no-radiative-forcing", is_flag=True, help = "Nao usar forcamento radiativo")
@click.option("--alpha", default=0.3, help = "Refletividade da Terra")
@click.option("--epsilon", default=0.6, help = "Emissividade da Terra")
@click.option("--rk-order", default=4, help = "Ordem do metodo Runge-Kutta")
@click.option("--atm-height", default=12_000, help = "Tamanho da Atmosfera")
@click.option("--solar-constant", default=1_367, help = "Constante Solar")
@click.option("--max-iterations", default=1_000_000, help = "Numero maximo de iteracoes - protecao numerica")
@click.option("--verbose", is_flag=True, help="Printar informacoes na tela")
@click.option("--export", is_flag=True, help = "Exportar dados como arquivo CSV")
@click.option("--plot", is_flag=True, help = "Plotar grafico com os dados da simulacao")
def main(ano_inicial, temp_inicial, **kwargs):
    """
    Resolve um modelo climatico de balanço de energia usando o metodo Runge-Kutta.
    """

    ano_final = kwargs.get("ano_final", dt.now().year)
    timestep = kwargs.get("timestep", 0.1)
    radiative_forcing = not kwargs.get("no_radiative_forcing", False)
    alpha = kwargs.get("alpha", 0.3)
    epsilon = kwargs.get("epsilon", 0.6)
    rk_order = kwargs.get("rk_order", 4)
    h_atm = kwargs.get("atm_height", 12_000)
    s0 = kwargs.get("solar_constant", 1_367)
    max_iterations = kwargs.get("max_iterations", 1_000_000)
    verbose = kwargs.get("verbose", False)
    export = kwargs.get("export", False)
    plot = kwargs.get("plot", False)

    ebm = EBM(ano_inicial, temp_inicial, h_atm, s0, alpha, epsilon, radiative_forcing, verbose)
    rk = RungeKutta(ebm.ode, timestep, rk_order, max_iterations, verbose)

    click.echo(f"Temperatura em {ano_inicial}: {ebm.kelvin_to_celsius(temp_inicial) :.2f} oC.")

    t_final = rk.solve((ano_inicial, temp_inicial), ano_final)

    click.echo(f"Temperatura estimada em {ano_final}: {ebm.kelvin_to_celsius(t_final) :.2f} oC.")
    deltaT = t_final - temp_inicial
    click.echo(f"{'Aquecimento' if deltaT > 0 else 'Resfriamento'} de {deltaT :.5f}oC.")

    if export:
        dp = rk.export_iteration_data()
        file_path = export_csv(dp)

        click.echo(f"Arquivo com os dados simulados salvo em: {file_path}")

    if plot:
        dp = rk.export_iteration_data()
        plot_data(dp)

if __name__ == '__main__':
    main()
