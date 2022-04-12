#!/usr/bin/env python

"""Numerical related tools that keep coming back up"""

from math import isclose

import numpy as np


def approx_lte(x, y):
    """Workaround for floating point precision <= comparison
    
    Parameters
    ----------
    x, y : float
        Numbers to be compared
    
    Returns
    -------
    bool
        Whether x <= y with some cushion for numerical precision
    
    """
    return x <= y or isclose(x, y)


def approx_gte(x, y):
    """Workaround for floating point precision >= comparison
    
    Parameters
    ----------
    x, y : float
        Numbers to be compared
    
    Returns
    -------
    bool
        Whether x >= y with some cushion for numerical precision 
        
    """
    
    return x >= y or isclose(x, y)


def ascolumns(a: np.ndarray):
    """Reshape an ndarray into columns

    Parameters
    ----------
    a : np.ndarray
        Any numpy array, usually I/Q data that we want vertically with 1+ vectors

    Returns
    -------
    np.ndarray

    """

    a = np.atleast_2d(a)
    if a.shape[1] > a.shape[0]:
        return a.T
    return a


def asrows(a: np.ndarray):
    """Reshape an ndarray into rows

    Parameters
    ----------
    a : np.ndarray
        Any numpy array, usually I/Q data that we want horizontally with 1+ vectors

    Returns
    -------
    np.ndarray

    """

    a = np.atleast_2d(a)
    if a.shape[0] > a.shape[1]:
        return a.T
    return a
