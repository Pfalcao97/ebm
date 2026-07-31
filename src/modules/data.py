from datetime import datetime as dt
import matplotlib.pyplot as plt
from pandas import DataFrame
from os import curdir

def export_csv(data_points:list) -> str:
    df = DataFrame(
        [
            {"Ano": p[0], "Temperatura [K]": p[1]}
            for p in data_points
        ]
    )

    timestamp = dt.now().strftime("%Y%m%d%H%M")
    file_path = f"{curdir}/ebm_rk_{timestamp}.csv"
    df["Temperatura [oC]"] =  df["Temperatura [K]"].apply(lambda x: x - 273.5)
    df.to_csv(file_path, index=False)

    return file_path

def plot_data(data_points:list):
    df = DataFrame(
        [
            {"Ano": p[0], "Temperatura [K]": p[1]}
            for p in data_points
        ]
    )

    ax = df.plot(
        x="Ano",
        y="Temperatura [K]",
        linewidth=2.5,
        marker=None,
        markersize=4,
        alpha=0.9,
        c = "red"
    )

    ax.set_title("Temperatura (K) vs Ano", pad=12)
    ax.set_xlabel("Ano")
    ax.set_ylabel("Temperatura (K)")

    # Grid and spines
    ax.grid(True, which="major", linestyle="--", alpha=0.35)
    ax.set_axisbelow(True)

    for spine in ax.spines.values():
        spine.set_alpha(0.6)

    plt.tight_layout()
    plt.show()
