/**
 *
 * @brief Add function implementation
 *
 * @file add.c
 * @author Guillermo Hernández
 * @date 16 Mar 2016
 *
 */

#include <stdio.h>
#include <stdlib.h>

#include "add.h"

#ifdef ONLY_CPU
inline int Add(const float *A, const float *B,float *C, int n) {
	return AddCPU(A, B,C, n);
}
inline int AddGPU(const float *A, const float *B,float *C, int n) {
	fprintf(stderr,"GPU function explicitly called in CPU mode. Using CPU implementation instead.\n");
	return AddCPU(A, B,C, n);
}
#else
inline int Add(const float *A, const float *B, float *C, int n) {
	return AddGPU(A, B, C, n);
}
#endif

int AddCPU(const float *A, const float *B, float *C, int n) {
	for (int i = 0; i < n; ++i)
		C[i] = A[i] + B[i];
	return 0;
}
