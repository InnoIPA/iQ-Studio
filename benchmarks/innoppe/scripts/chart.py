# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import matplotlib.pyplot as plt


class Colors:
    sensing = "#fabe23"
    data = "#0046ff"
    connecting = "#007800"
    extended = "#00b4ff"
    computing = "#00dc00"
    machine_learning = "#BE0078"
    management = "#ff00ff"
    collective = "#ff6900"


def draw_bars(
    ax,
    items,
    metrics,
    xlim=(0, 500),
    color=("#7ad8ff", Colors.extended),
    bar_label_color="black",
    title="CPU Usage",
    label="Percentage",
):
    # Draw horizontal bar chart
    bars = ax.barh(items, metrics, color=color)  # , edgecolor='#929496')

    # Add value labels and notes
    for bar, metric in zip(bars, metrics):
        ax.text(
            max(bar.get_width() / 5, bar.get_x() + bar.get_width() - xlim[1] * 0.092),
            bar.get_y() + bar.get_height() / 2,
            f"{metric:.1f}",
            va="center",
            ha="left",
            horizontalalignment="right",
            fontsize=9,
            color=bar_label_color,
        )

    # Add titles and labels
    ax.set_axisbelow(True)
    ax.set_title(title, loc="center", fontsize=13)
    ax.set_xlabel(label, fontsize=7, loc="right")
    ax.set_xlim(*xlim)
    ax.grid(axis="x", linestyle="--")


machines = ["NVIDIA Jetson AGX Orin", "IQ-9075-EVK"]

# cpu_usages = [97.84, 97.78]
# memory_usages = [31.63, 24.15]
# network_usages = [1.63, 0.42]  # MB/s
# frame_rates = [8, 11]  # FPS
# accelerator_usages = [67, 78]

cpu_usages = [96.99, 99.61]
memory_usages = [25.70, 14.61]
network_usages = [0.67, 5.99]  # MB/s
frame_rates = [8, 25]  # FPS
accelerator_usages = [51.52, 67.15]

fig, axs = plt.subplots(ncols=2, nrows=3, figsize=(10, 6), layout="constrained")

draw_bars(axs[0][0], machines, cpu_usages, xlim=(0, 100))
draw_bars(
    axs[0][1],
    machines,
    memory_usages,
    xlim=(0, 100),
    title="Memory Usage",
    label="Percentage, Less is Better",
)
draw_bars(
    axs[1][0], machines, accelerator_usages, xlim=(0, 100), title="Accelerator Usage"
)
draw_bars(
    axs[1][1],
    machines,
    network_usages,
    xlim=(0, 8),
    title="Network Usage",
    label="MB/s, Less is Better",
)
draw_bars(
    axs[2][0],
    machines,
    frame_rates,
    xlim=(0, 30),
    title="FPS",
    label="Frames per Seconds, More is Better",
)
fig.delaxes(axs[2][1])  # hide the last one

fig.suptitle("Performance metrics while running 10 InnoPPE channels", fontsize=19)
fig.savefig("results.svg", pad_inches=0.1, bbox_inches="tight")
