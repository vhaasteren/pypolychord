# Whether to run in debugging mode (leave blank if running in optimised mode
DEBUG = 
export DEBUG

# Whether to use MPI or not (leave blank if running without MPI)
MPI =
export MPI

# The compiler type:
# This sets up the correct compiler flags
# current options are:
#  * gfortran
#  * ifort
COMPILER_TYPE = gfortran
export COMPILER_TYPE

default: all

libchord.so: ./src/*90
	cd ./src && make libchord.so && cd ..

libchord.a: ./src/*90
	cd ./src && make libchord.a && cd ..

main: ./src/*90
	cd ./src && make libchord.a && make libchord.so && make main && cd ..

clean:
	cd ./src && make clean && cd ..

veryclean:
	rm main && cd ./src && make veryclean && cd ..

all: libchord.a libchord.so
