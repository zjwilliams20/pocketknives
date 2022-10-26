#!/usr/bin/env python

"""Useful things to have in your back-pocket"""

import inspect
import re
from functools import wraps
import math
import sys
from time import perf_counter

import numpy as np


def dump_locals():
    """Print all the local variables in the caller with formatting"""

    frame = inspect.currentframe()
    outer_frame = inspect.getouterframes(frame)[1]
    print(f"Function: '{outer_frame.function}'")
    print(f"File: '{outer_frame.filename}'")

    caller_locals = frame.f_back.f_locals
    for k, v in caller_locals.items():
        v = brief(v)
        print(f"\t'{k}': {v}")


def uncomment_json(contents: str):
    """Uncomment the given .json contents

    Parameters
    ----------
    contents : str
        Contents of the json file with comments

    Returns
    -------
    str
        json contents without comments

    """
    return re.sub("//.+?\n", "\n", contents)


def timer(func, verbose=True):
    """Function timer decorator"""

    @wraps(func)
    def wrapper(*args, **kwargs):
        t0 = perf_counter()
        ret = func(*args, **kwargs)
        T = perf_counter() - t0

        inputs = ""
        if verbose:
            inputs = f"({[brief(arg) for arg in args]}, {kwargs})"
        print(f"{func.__name__}{inputs} took {T*1e3:.5g} ms.")

        return ret

    return wrapper


def brief(a):
    """Summarize an array-like object by shape and dtype if too large

    Parameters
    ----------
    a : object
        Handles np.ndarray and torch.tensor

    Returns
    -------
    str

    """

    MAX_SIZE = 20
    if hasattr(a, "shape") and np.prod(a.shape) > MAX_SIZE:
        ret = f"{a.__class__.__name__}({a.shape}, {a.dtype})"
        if hasattr(a, "nbytes"):
            return f"{ret[:-1]}, {eng_string(a.nbytes)}B)"
        return ret
    return repr(a)


# Shamelessly stolen from:
#   https://stackoverflow.com/questions/17973278/python-decimal-engineering-notation-for-mili-10e-3-and-micro-10e-6
def eng_string(x, si=True):
    """Convert numeric to engineering format

    Parameters
    ----------
    si: bool, default=True
        If true, use SI suffix for exponent, e.g. k instead of e3, n instead of e-9 etc.

    Extended Summary
    ----------------
    Returns float/int value <x> formatted in a simplified engineering format -
    using an exponent that is a multiple of 3.

    """

    x = float(x)

    sign = ""
    if x < 0:
        x = -x
        sign = "-"
    exp = int(math.floor(math.log10(x)))
    exp3 = exp - (exp % 3)
    x3 = x / (10**exp3)

    if si and exp3 >= -24 and exp3 <= 24 and exp3 != 0:
        exp3_text = "yzafpnum kMGTPEZY"[(exp3 - (-24)) // 3]
    elif exp3 == 0:
        exp3_text = ""
    else:
        exp3_text = "e%s" % exp3

    return f"{sign}{x3}{exp3_text}"

def progressbar(it, prefix="", size=60, skip=1, out=sys.stdout):
    """Simple built-in progress bar
    
    Reference:
        https://stackoverflow.com/questions/3160699/python-progress-bar
    Changes:
     - changed fill character '█' -> '-'
     - added skip parameter to only print on certain iterations
    """
    
    count = len(it)
    def show(j):
        x = size * j // count
        print(f"{prefix}[{u'-'*x}{('.'*(size-x))}] {j}/{count}", end='\r', file=out, flush=True)
    show(0)
    for i, item in enumerate(it):
        yield item
        if not (i+1) % skip:
            show(i+1)
    print("\n", flush=True, file=out)


