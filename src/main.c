/**
 *
 * @brief Main file of project containing example of integrating C Cuda into C.
 *
 * @file main.c
 * @author Guillermo Hernández
 * @date 16 Mar 2016
 *
 *
 * This project includes examples of some tools I would like to use in my future projects.
 * It features:
 * 	- Compilation with only CPU C-implemented code and with GPU CUDA C-implemented alternative
 * 	- Both makefile and Nsight (Eclipse) compilation tools
 * 	- Doxygen for documentation
 * 	- Unit test support using CuTest
 * 	- Git-ready structure
 *
 * 	@see http://www.stack.nl/~dimitri/doxygen/index.html
 * 	@see http://cutest.sourceforge.net/
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "add.h"

int main(int argc, char **argv) {

	// Print the vector length to be used, and compute its size
	int numElements = 50000;
	size_t size = numElements * sizeof(float);
	printf("Vector addition of %d elements\n", numElements);

	// Allocate vectors
	float *A = (float *) malloc(size);
	float *B = (float *) malloc(size);
	float *C = (float *) malloc(size);
	float *C2 = (float *) malloc(size);
	float *C3 = (float *) malloc(size);

	// Verify that allocations succeeded
	if (A == NULL || B == NULL || C == NULL || C2 == NULL || C3==NULL) {
		fprintf(stderr, "Failed to allocate vectors!\n");
		exit(EXIT_FAILURE);
	}

	// Initialize with random numbers
	for (int i = 0; i < numElements; ++i) {
		A[i] = rand() / (float) RAND_MAX;
		B[i] = rand() / (float) RAND_MAX;
	}

	//Add with GPU
	AddGPU(A, B, C, numElements);
	//Call with CPU
	AddCPU(A, B, C2, numElements);
	//Call with compilation chosen function (GPU if available, otherwise CPU)
	Add(A, B, C3, numElements);

	//Check the results
	for (int i = 0; i < numElements; ++i) {
		if (fabs(A[i] + B[i] - C[i]) > 1e-5) {
			fprintf(stderr, "GPU add verification failed at element %d!\n", i);
			exit(EXIT_FAILURE);
		}
	}
	for (int i = 0; i < numElements; ++i) {
		if (fabs(A[i] + B[i] - C2[i]) > 1e-5) {
			fprintf(stderr, "CPU add verification failed at element %d!\n",
					i);
			exit(EXIT_FAILURE);
		}
	}
	for (int i = 0; i < numElements; ++i) {
			if (fabs(A[i] + B[i] - C3[i]) > 1e-5) {
				fprintf(stderr, "Add verification failed at element %d!\n",
						i);
				exit(EXIT_FAILURE);
			}
	}

	// Free memory
	free(A);
	free(B);
	free(C);
	free(C2);
	printf("Done! :D\n");
	return 0;
}
