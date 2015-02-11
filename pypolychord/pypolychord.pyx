import os, math, re, time
from distutils.version import StrictVersion

from libc cimport stdlib, stdio
from cython cimport view

import numpy
cimport numpy

cdef extern from "polychord.h":
    void __initsampler_MOD_dosamplingfromc(double (*Lfunc)(int nDims, double *theta, int nDerived, double *phi, void *context), int Ndim, int nDerived, int nLive, int Nchords,  double *PriorsArray, char *Froot, void *context);

def dosampling(loglike, ndim, nlive, nchords, parray, root, context):
    froot = root + ' ' * (100 - len(root))

    __initsampler_MOD_dosamplingfromc(loglike, ndim, 0, nlive, nchords, parray,
            root, None)

