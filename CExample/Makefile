# Options
# CC = icc/gcc
# FC = ifort/gfortran
CC = gcc
FC = gfortran

CHORDLIBDIR = ../src/
LIBS =  -L$(CHORDLIBDIR) -lchord -lstdc++
 
OBJFILES = eggbox.o

all: eggbox 

%.o: %.cpp
	$(CC) $(CFLAGS) -c $*.cpp
 
eggbox: $(OBJFILES)
	$(FC) $(FFLAGS) -o eggboxC $(OBJFILES) $(LIBS)
	# For ifort:
	#$(FC) $(FFLAGS) -nofor_main -o eggboxC $(OBJFILES) $(LIBS)

clean:
	rm -f *.o *.mod eggboxC
