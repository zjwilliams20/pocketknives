#!/usr/bin/env python

"""Logging related utilities"""

import atexit
import logging
import sys


FORMAT = '%(asctime)s.%(msecs)03d [%(name)-5s] %(levelname)-8s %(message)s'


class ColorFormatter(logging.Formatter):
    
    RESET = "\x1b[0m"

    COLORS = {
        'red': "\x1b[31m",
        'green': "\x1b[32m",
        'yellow': "\x1b[33m",
        'blue': "\x1b[34m",
        'magenta': "\x1b[35m",
        'cyan': "\x1b[36m",
        'grey': "\x1b[37m",
        'white': "\x1b[38m",
        'ENDC': "\x1b[0m"
    }

    CMAP = {
        'a': f"{COLORS['magenta']}{FORMAT}{RESET}",
        'b': f"{COLORS['yellow']}{FORMAT}{RESET}",
        'c': f"{COLORS['blue']}{FORMAT}{RESET}",
        'd': f"{COLORS['cyan']}{FORMAT}{RESET}",
        'e': f"{COLORS['white']}{FORMAT}{RESET}",
        'f': f"{COLORS['green']}{FORMAT}{RESET}"
    }

    def format(self, record):
        log_fmt = self.CMAP.get(record.name)
        formatter = logging.Formatter(log_fmt, datefmt='%I:%M:%S')
        return formatter.format(record)


def get_logger(name, logfilename="", level=logging.DEBUG):
    """Generates a logger that pipes to the console with formatting
    
    Parameters
    ----------
    name : str
        Name of the logger instance
    logfilename : str
        Name of the file to log to, default means no file
    level : int, default=logging.DEBUG
        Severity of logs to watch
        
    Returns
    -------
    logger : logging.Logger
    
    """

    def close_logfile(logger):
        """Close the log file to prevent ResourceWarning's for us not cleaning up our mess"""

        for handler in logger.handlers:
            handler.close()
            logger.removeHandler(handler)

    logger = logging.getLogger(name)
    stream_handler = logging.StreamHandler(sys.stdout)

    # Clear previous handlers.
    if logger.hasHandlers():
        close_logfile(logger)
        logger.handlers = []

    # Create a log file if the variable is set.
    if logfilename:
        file_handler = logging.FileHandler(logfilename, mode='a')

        file_handler.setFormatter(logging.Formatter(FORMAT, datefmt='%I:%M:%S'))
        logger.addHandler(file_handler)

        # Register the log file closer upon exit.
        atexit.register(close_logfile, logger)

    stream_handler.setFormatter(ColorFormatter())
    logger.addHandler(stream_handler)
    logger.setLevel(level)

    # Do not propogate calls to the root logger.
    logger.propogate = False
    
    return logger

