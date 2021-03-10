#include <iostream>
#include "cuda_runtime.h"
#include <cufft.h>
#include <stdio.h>

#define FFTCompute _declspec(dllexport)
#define MyFunc _declspec(dllexport)

extern "C" {
	MyFunc int addNums(int a, int b) {
		return a + b;
	}

	FFTCompute float** computeFFT(float *numbers, int size) {

		size_t memorySize = size * sizeof(cufftComplex);
		int complexItemNumbers = size / 2 + 1;

		float* device_input;
		cufftComplex* host_output;
		cufftComplex* device_output;
		cufftHandle plan;

		//allocate host memory for output
		host_output = (cufftComplex*)malloc((size / 2 + 1) * sizeof(cufftComplex));
		//allocate memory for final output;

		//allocate device memory for input
		cudaMalloc(&device_input, size * sizeof(float));
		//allocate device memory for output
		cudaMalloc(&device_output, (size/2 + 1) * sizeof(cufftComplex));
		// creating 1D plan
		cufftPlan1d(&plan, size, CUFFT_R2C, 1);
		// copying numbers array to device memory
		cudaMemcpy(device_input, numbers,
			size * sizeof(float), cudaMemcpyHostToDevice);
		// run fowards fft, real to complex
		cufftExecR2C(plan, device_input, device_output);
		//copying output from device to host
		cudaMemcpy(host_output, device_output, 
			(size/2+1) * sizeof(cufftComplex), cudaMemcpyDeviceToHost);

		// copying output to 2D array to return
		float** output = new float*[complexItemNumbers];
		for (int i = 0; i < complexItemNumbers; i++) {
			output[i] = new float[2];
		}

		for (int i = 0; i < complexItemNumbers; i++) {
			output[i][0] = host_output[i].x;
			output[i][1] = host_output[i].y;
		}

		return output;
	}
}