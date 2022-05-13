#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

__global__ void Square(int* GPU_IN, int* GPU_OUT)
{
	int idx = threadIdx.x;
	int n = GPU_IN[idx];
	GPU_OUT[idx] = n * n;
	//printf("%d\n", GPU_OUT[idx]);
}

int main()
{
	const int Array_Length = 21;
	const int Array_Size = Array_Length * sizeof(int);

	int* CPU_IN = (int *)malloc(Array_Size);
	int* CPU_OUT = (int*)malloc(Array_Size);
	for (int i = 0;i < Array_Length;i++)
	{
		CPU_IN[i] = i;
		//CPU_OUT[i] = 0;
		//printf("%d\n", CPU_IN[i]);
	}
	int* GPU_IN, * GPU_OUT;
	cudaMalloc(& GPU_IN, Array_Size);
	cudaMalloc(& GPU_OUT, Array_Size);
	cudaMemcpy(GPU_IN, CPU_IN, Array_Size, cudaMemcpyHostToDevice);

	Square <<<1, Array_Length >>> (GPU_IN, GPU_OUT);
	cudaDeviceSynchronize();
	cudaMemcpy(CPU_OUT, GPU_OUT, Array_Size, cudaMemcpyDeviceToHost);
	for (int i = 0;i < Array_Length;i++)
	{
		printf("%d\n", CPU_OUT[i]);
	}
	free(CPU_IN);
	free(CPU_OUT);
	cudaFree(GPU_IN);
	cudaFree(GPU_OUT);
}