from __future__ import print_function
from __future__ import division

import numpy as np
import pypolychord as pp
import ctypes

def loglik(ndim, theta, phi):
    return -0.5 * np.sum(theta**2)

if __name__ == "__main__":
    ndim = 20
    prior_array = np.append([-10.0]*ndim, [10.0]*ndim)

    pp.run(loglik, ndim, prior_array, n_live=500, n_chords=1, output_basename='pc/2-')

    # Analytical is
    print("Analytical = ", 0.5*ndim*np.log(2*np.pi)-ndim*np.log(20))
