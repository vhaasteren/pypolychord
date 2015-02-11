from __future__ import absolute_import, unicode_literals, print_function
from ctypes import cdll
import numpy as np

try:
	lib = cdll.LoadLibrary('libchord.so')
except OSError as e:
	if e.message == 'libchord.so: cannot open shared object file: No such file or directory':
		print()
		print('ERROR:   Could not load PolyChord library "libchord.so"')
		print('ERROR:   You have to build it first,,')
		print('ERROR:   and point the LD_LIBRARY_PATH environment variable to it!')
		#print('ERROR:   manual: http://blahblah.html')
		print()
	if e.message.endswith('cannot open shared object file: No such file or directory'):
		print()
		print('ERROR:   Could not load PolyChord library: %s' % e.message.split(':')[0])
		print('ERROR:   You have to build PolyChord,')
		print('ERROR:   and point the LD_LIBRARY_PATH environment variable to it!')
		#print('ERROR:   manual: http://blahblah.html')
		print()
	# the next if is useless because we can not catch symbol lookup errors (the executable crashes)
	# but it is still there as documentation.
	if 'symbol lookup error' in e.message and 'mpi' in e.message:
		print()
		print('ERROR:   You are trying to get MPI to run, but MPI failed to load.')
		print('ERROR:   Specifically, mpi symbols are missing in the executable.')
		print('ERROR:   Let me know if this is a problem of running python or a compilation problem.')
		#print('ERROR:   manual: http://blahblah.html')
		print()
	# what if built with MPI, but don't have MPI
	print('problem:', e)
	import sys
	sys.exit(1)

from ctypes import *
import ctypes

def run(LogLikelihood, \
        Prior, \
	n_dims, \
        prior_array, \
        n_live=500, \
        n_chords=1, \
        root="chains/pc-"):
	"""
	Runs PolyChord
	
	"""

        loglike_type = CFUNCTYPE(c_double, c_int, POINTER(c_double), c_int, \
                POINTER(c_double), c_void_p)

        def loglike(n_dims, theta, nderived, phi, context):
            theta_pointer = cast(theta, POINTER(c_double))
            phi_pointer = cast(phi, POINTER(c_double))
            theta_arr = np.frombuffer(theta_pointer.contents)
            phi_arr = np.frombuffer(phi_pointer.contents)

            args = [n_dims, theta_arr, phi_arr]

            return LogLikelihood(*args)

        c_double_p = ctypes.POINTER(ctypes.c_double)
        prior_array_p = prior_array.ctypes.data_as(c_double_p)
        
        Froot = root + ' ' * (100 - len(root))
        lib.__initsampler_MOD_dosamplingfromc(loglike_type(loglike),
                byref(c_int(n_dims)), byref(c_int(0)), byref(c_int(n_live)),
                byref(c_int(n_chords)),
                prior_array_p,
                create_string_buffer(Froot.encode(),100),
                None)

