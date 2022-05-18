#!/usr/bin/env python

"""Matplotlib specific plotting helpers"""

import matplotlib.pyplot as plt


def ticks_off(ax=None):
    """Turn off all tick annotations on plt.gcf()"""
    if ax:
        plt.sca(ax)
    plt.tick_params(
        axis='both', which='both', 
        labelbottom=False, labelleft=False, 
        right=False, left=False, bottom=False, top=False) 

    