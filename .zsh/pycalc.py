#!/bin/python

from __future__ import print_function

from itertools import *
from random import *
from math import *
import sys, os, re, math, string
try:
  import numpy as np
except ImportError:
  pass

def log2(x):
  return log(x, 2)

print(eval(' '.join(sys.argv[1:])))
