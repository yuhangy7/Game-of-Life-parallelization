#include "life.h"
#include "util.h"
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#define SWAP_BOARDS( b1, b2 )  do { \
  char* temp = b1; \
  b1 = b2; \
  b2 = temp; \
} while(0)

#define BOARD( __board, __i, __j )  (__board[(__i) + LDA*(__j)])

__device__ int d_mod_v3 (int x, int m)
{
  return (x < 0) ? ((x % m) + m) : (x % m);
}

__device__ char d_alivep_v3 (char count, char state)
{
  return (! state && (count == (char) 3)) ||
    (state && (count >= 2) && (count <= 3));
}

__global__ void GPUInnerLoop_v3(char *outboard, char *inboard, int nrows, int ncols) 
{
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  int j = blockIdx.y * blockDim.y + threadIdx.y;
 
  if (i < nrows && j < ncols) {
    const int inorth = d_mod_v3 (i-1, nrows);
    const int isouth = d_mod_v3 (i+1, nrows);
    const int jwest = d_mod_v3 (j-1, ncols);
    const int jeast = d_mod_v3 (j+1, ncols);
    const int LDA = nrows;
    const char neighbor_count = 
        BOARD (inboard, inorth, jwest) + 
        BOARD (inboard, inorth, j) + 
        BOARD (inboard, inorth, jeast) + 
        BOARD (inboard, i, jwest) +
        BOARD (inboard, i, jeast) + 
        BOARD (inboard, isouth, jwest) +
        BOARD (inboard, isouth, j) + 
        BOARD (inboard, isouth, jeast);
    //printf("%c\n", d_alivep (neighbor_count, BOARD (inboard, i, j)));
    BOARD(outboard, i, j) = d_alivep_v3 (neighbor_count, BOARD (inboard, i, j));
  }
}

char* cuda_v3_game_of_life (
    char* outboard, 
    char* inboard,
    const int nrows,
    const int ncols,
    const int gens_max,
    const int version,
    const int num_threads,
    const int num_blocks) 
{
    const int LDA = nrows;
    int curgen, i, j;
    printf("current version is: %d\n", version);
    char * d_inboard;
    char * d_outboard;
    cudaMalloc((void**)&d_inboard, sizeof(char) * nrows * ncols);
    cudaMalloc((void**)&d_outboard, sizeof(char) * nrows * ncols);
    cudaMemcpy(d_inboard, inboard, sizeof(char) * nrows * ncols, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(16, 16);
    dim3 numBlocks(nrows / threadsPerBlock.x + 1, ncols / threadsPerBlock.y + 1);
    for (curgen = 0; curgen < gens_max; curgen++)
    {
        GPUInnerLoop_v3<<<numBlocks, threadsPerBlock>>>(d_outboard, d_inboard, nrows, ncols);
        cudaDeviceSynchronize();
        SWAP_BOARDS( d_outboard, d_inboard );
    }
    cudaMemcpy(inboard, d_inboard, sizeof(char) * nrows * ncols, cudaMemcpyDeviceToHost);
    cudaFree(d_inboard);
	  cudaFree(d_outboard); 
 
    
    /* 
    * We return the output board, so that we know which one contains
    * the final result (because we've been swapping boards around).
    * Just be careful when you free() the two boards, so that you don't
    * free the same one twice!!! 
    */
    return inboard;
}