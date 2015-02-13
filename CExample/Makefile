# Options
# CC = icc/gcc
# FC = ifort/gfortran
CC = gcc
FC = gfortran

CHORDLIBDIR = ../src/
LIBS =  -L$(CHORDLIBDIR) -lchord -lstdc++
 
OBJFILESE = eggbox.o

OBJFILESG = gaussian.o

all: eggbox gaussian

%.o: %.cpp
	$(CC) $(CFLAGS) -c $*.cpp
 
eggbox: $(OBJFILESE)
	$(FC) $(FFLAGS) -o eggboxC $(OBJFILESE) $(LIBS)
	# For ifort:
	#$(FC) $(FFLAGS) -nofor_main -o eggboxC $(OBJFILESE) $(LIBS)

gaussian: $(OBJFILESG)
	$(FC) $(FFLAGS) -o gaussianC $(OBJFILESG) $(LIBS)

clean:
	rm -f *.o *.mod eggboxC gaussianC
