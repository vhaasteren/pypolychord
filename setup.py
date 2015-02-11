#!/usr/bin/env python
# -*- coding: utf-8 -*-

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import numpy

setup(
    name = "pypolychord",
    version = "0.01",
    description = "Python interface to PolyChord",
    author = "Rutger van Haasteren",
    author_email = "vhaasteren [@t] gmail.com",
    maintainer = "Rutger van Haasteren",
    maintainer_email = "vhaasteren [@t] gmail.com",
    url = "http://vhaasteren.github.com/pypolychord/",
    license = "GPLv3",
    packages = ["pypolychord"],
    provides = ["pypolychord"],
    requires = ["numpy (>=1.5)", "matplotlib", "scipy"],
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: GNU General Public License (GPL)",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
    ],
    py_modules = [],
    ext_modules = cythonize(Extension('pypolychord.pypolychord',['pypolychord/pypolychord.pyx'],
                    language="c++",
                    include_dirs = [numpy.get_include()],
                    libraries = ['chord'],
                    library_dirs = ['/Users/vhaaster/local/lib']))
    #    scripts=['multinest_marginals.py'],
)

