from __future__ import print_function
from __future__ import division

import numpy as np
import pymultinest as pm
import ctypes

def loglik(cube, ndim, nparams):
    acube = np.zeros(ndim)

    for ii in range(ndim):
        acube[ii] = cube[ii]

    return -0.5 * np.sum(acube**2)

def samplefromprior(cube, ndim, nparams):
    for ii in range(ndim):
        cube[ii] = -10.0 + cube[ii] * 20.0

if __name__ == "__main__":
    ndim = 256

    pm.run(loglik, samplefromprior, ndim,
            importance_nested_sampling = False,
            const_efficiency_mode=False,
            n_clustering_params = None,
            resume = False,
            verbose = True,
            n_live_points = 2000,
            init_MPI = False,
            multimodal = True,
            outputfiles_basename='chains/1-',
            n_iter_before_update=100,
            seed=16,
            max_modes=100,
            evidence_tolerance=0.5,
            write_output=True,
            sampling_efficiency = 0.3)

    # Analytical is
    print("Analytical = ", 0.5*ndim*np.log(2*np.pi)-ndim*np.log(20))
