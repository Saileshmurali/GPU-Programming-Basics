
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "device_atomic_functions.h"
#include "cuda_runtime_api.h"
#include "cuda.h"
#include <stdio.h>
#include <stdlib.h>


__global__ void AtomicAddCheck(int* d_pointer)
{
	int idx = threadIdx.x;
	__shared__ int val;
	val = 0;
	if (idx % 2 == 0)
	{
		atomicAdd(&val, 1);
		*d_pointer = val;
	}
	else
	{
		atomicAdd(&val, 2);
		*d_pointer = val;
	}

}

int main()
{
	int h_var = 0, h_threads = 100;
	int* h_pointer = &h_var;
	int* d_pointer;
	cudaMalloc(&d_pointer, sizeof(int));
	cudaMemcpy(d_pointer, h_pointer, sizeof(int), cudaMemcpyHostToDevice);

	AtomicAddCheck << <1, 100 >> > (d_pointer);
	cudaDeviceSynchronize();
	cudaMemcpy(h_pointer, d_pointer, sizeof(int), cudaMemcpyDeviceToHost);
	printf("The sum is %d", *h_pointer);
}