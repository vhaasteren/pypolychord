#!/usr/bin/env python
# -*- coding: utf-8 -*-

try:
    from setuptools import setup
except:
    from distutils.core import setup

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
    ]
    #    scripts=['multinest_marginals.py'],
)

