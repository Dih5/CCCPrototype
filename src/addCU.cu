/**
 *
 * @brief Add function GPU implementation
 *
 * @file addCU.cu
 * @author Guillermo Hernández
 * @date 16 Mar 2016
 *
 */

// System includes
#include <stdlib.h>
#include <stdio.h>

// CUDA runtime
#include <cuda_runtime.h>



/**
 * @brief Macro to check for CUDA errors
 *
 * If code!=cudaSuccess (0) it prints a message in stderr and returns 1.
 *
 * @param code integer code returned by last CUDA-related function (cudaMalloc, cudaGetLastError,...)
 * @param msg a string describing the error
 */
#define checkError(code,msg) if (code != cudaSuccess) {\
		fprintf(stderr, msg);\
		fprintf(stderr,"(error code %s)\n",cudaGetErrorString(err));\
		return 1;\
	}

/**
 * @brief CUDA Kernel to calculate vector addition
 *
 * Kernel to computes the vector addition of @p A and @p B into @p C, all of them having @p n elements
 */
__global__ void
vectorAdd(const float *A, const float *B, float *C, int n)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < n)
    {
        C[i] = A[i] + B[i];
    }
}



extern "C"
int AddGPU(const float *h_A, const float *h_B,float *h_C, int n)
{
	// GPU implementation must wrap the call to the kernel

	// Error code to check return values for CUDA calls
	cudaError_t err = cudaSuccess;


	size_t size = n * sizeof(float);
	// Allocate the device input vectors
	float *d_A = NULL;
	err = cudaMalloc((void **) &d_A, size);
	checkError(err,"Failed to allocate device vector A");


	float *d_B = NULL;
	err = cudaMalloc((void **) &d_B, size);
	checkError(err,"Failed to allocate device vector B");



	float *d_C = NULL;
	err = cudaMalloc((void **) &d_C, size);
	checkError(err,"Failed to allocate device vector C");


	// Copy input to device memory
	err = cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	checkError(err,"Failed to copy vector A from host to device");

	err = cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
	checkError(err,"Failed to copy vector B from host to device");

	// Launch the kernel
	int threadsPerBlock = 256;
	int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;
	printf("CUDA kernel launch with %d blocks of %d threads\n", blocksPerGrid,
			threadsPerBlock);
	vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, n);
	err = cudaGetLastError();
	checkError(err,"Failed to launch vectorAdd kernel");


	// Copy the device result vector in device memory to the host result vector
	// in host memory.
	err = cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
	checkError(err,"Failed to copy vector C from device to host");


	// Free device global memory
	err = cudaFree(d_A);
	checkError(err,"Failed to free device vector A");

	err = cudaFree(d_B);
	checkError(err,"Failed to free device vector B");

	err = cudaFree(d_C);
	checkError(err,"Failed to free device vector C");



	return 0;
}
