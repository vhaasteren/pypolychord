from __future__ import print_function
from __future__ import division

import numpy as np
import run
import ctypes

def loglik(ndim, theta, phi):
    return (np.prod(np.cos(theta/2.0))+2.0)**5.0

if __name__ == "__main__":
    ndim = 2
    prior_array = np.append([0.0]*ndim, [10.0*np.pi]*ndim)

    run.run(loglik, ndim, prior_array, n_live=500, n_chords=1)
