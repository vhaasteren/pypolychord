# PyPolyChord #

Alpha release of the Python wrapper for PolyChord

Note: this version of PyPolyChord is provided as is, and severe tweaks are
necessary to make it work. Apologies for that, but I just have not had the
occasion to make this a priority. I am releasing it in the hope it will be
useful.

## How to make it work ##

* git checkout b584b4346503c7da34eb191ba1c4cecbc37591cb
* make clean
* make libchord.so
* cp src/libchord.so somethinginyourlibpath
* cd pypolychord
* python test.py

If that worked, then you can do:

* checkout master
* python setup.py install
* Run the python test in pypolychord (notebook, or test.py)

## Manual ##
Under construction.


## Requirements ##

* Python 2.7
* [numpy](http://numpy.scipy.org)
* [scipy](http://numpy.scipy.org)
* [matplotlib](http://matplotlib.org), for plotting only

## Contact ##

* [_Rutger van Haasteren_](mailto:vhaasteren@gmail.com)

