"""
=====================
Pocketknives (python)
=====================
    
Tools
-----

  - dump_locals - handy debugging tool that pretty prints all variables in
    local memory
  - timer - function timer decorator
  - eng_string - format and prefix a numeric object with its SI notation
  - brief - summarize large ndarrays with shape and dtype
  - uncomment_json - uncomment json string
  
Numeric
-------

  - factors - compute a list of factors for a given integer
  - approx_lte/approx_gte - legible <=/>= for floats with absolute tolerance
  - ascolumns/asrows - converts the ndarray to two dimensions and puts the 
    larger dimension as columns or rows

Miscellaneous
-------------

  - ticks_off - turn off all tick marks and axes notations on plt.gcf()
  - set_bounds - Set the axis on plt.gca() within some margin of the xy data
  - get_logger - generic logger utility with hardcoded colors by module name
  - ColorFormatter - boilerplate class that implements color logging


"""

from .python import *
