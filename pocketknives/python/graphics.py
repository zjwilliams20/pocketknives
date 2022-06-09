#!/usr/bin/env python

"""Matplotlib specific plotting helpers"""

import numpy as np
import matplotlib.pyplot as plt


def ticks_off(ax=None):
    """Turn off all tick annotations on plt.gcf()"""
    if ax:
        plt.sca(ax)
    plt.tick_params(
        axis="both",
        which="both",
        labelbottom=False,
        labelleft=False,
        right=False,
        left=False,
        bottom=False,
        top=False,
    )


def set_bounds(xydata, ax=None, zoom=0.1):
    """Set the axis on plt.gca() by some margin beyond the data, default 10% margin"""

    xydata = np.atleast_2d(xydata)

    if not ax:
        ax = plt.gca()

    xmarg = xydata[:, 0].ptp() * zoom
    ymarg = xydata[:, 1].ptp() * zoom
    ax.set(
        xlim=(xydata[:, 0].min() - xmarg, xydata[:, 0].max() + xmarg),
        ylim=(xydata[:, 1].min() - ymarg, xydata[:, 1].max() + ymarg),
    )
