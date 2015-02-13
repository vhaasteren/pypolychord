#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <float.h>
#include "polychord.h"



/******************************************** loglikelihood routine ****************************************************/

// Now an example, sample an egg box likelihood

// Input arguments
// ndim 						= dimensionality (total number of free parameters) of the problem
// npars 						= total number of free plus derived parameters
// context						void pointer, any additional information
//
// Input/Output arguments
// Cube[npars] 						= on entry has the ndim parameters in unit-hypercube
//	 						on exit, the physical parameters plus copy any derived parameters you want to store with the free parameters
//	 
// Output arguments
// lnew 						= loglikelihood

double LogLike(int &ndim, double *theta, int &nderived, double *phi, void *context)
{

	double chi = 1.0;
	double lnew=0;
	int i;
	for(i = 0; i < ndim; i++)
	{
		double x = theta[i];
		chi *= cos(x/2.0);
		//Cube[i] = x;
	}
	lnew = powf(chi + 2.0, 5.0);

	return lnew;
}

/***********************************************************************************************************************/


/************************************************** Main program *******************************************************/



int main(int argc, char *argv[])
{
	
	// set the PolyChord sampling parameters
	
	int Ndim = 2;
	int nDerived = 0;
	int nLive = 500;
	int Nchords = 1;

	double *PriorsArray = new double[2*Ndim];	

	PriorsArray[0] = 0;
	PriorsArray[1] = 0;

	PriorsArray[2] = 10.0*M_PI;
	PriorsArray[3] = 10.0*M_PI;
	
	char Froot[100] = "chains/eggboxC-";		// root for output files
	
	void *context = 0;				// not required by PolyChord, any additional information user wants to pass

	double *output = new double[5];

	/////////////////////////Sort Grade stuff////////////////////////////	

	int do_grades = 0;
	int *grades = new int[Ndim];
	for(int i = 0; i < Ndim; i++){
		grades[i] = 1;
	}

	int maxgrade = 1;
	int *grade_repeats = new int[maxgrade];
	for(int i = 0; i < maxgrade; i++){
		grade_repeats[i] = 1;
	}


	int *hypercube_indices = new int[Ndim];
	int *physical_indices = new int[Ndim];

	//Set indices, note this is fortran convention -> starts from 1/////
	for(int i = 0; i < Ndim; i++){
		hypercube_indices[i] = i+1;
		physical_indices[i] = i+1;
	}
	
	// calling PolyChord
	
	chord::Sample(LogLike, Ndim, nDerived, nLive, Nchords,  PriorsArray, Froot, context, output, do_grades, maxgrade, grades, grade_repeats, hypercube_indices, physical_indices);	


	printf("Sampling finished, output:\n");
	for(int i = 0; i < 5; i++){
		printf("Output %i %g \n", i, output[i]);
	}

	delete[] output;
	delete[] grades;
	delete[] grade_repeats;
	delete[] hypercube_indices;
	delete[] physical_indices;
	delete[] PriorsArray;
}

/***********************************************************************************************************************/
