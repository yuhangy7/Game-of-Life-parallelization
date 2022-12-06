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

// __global__ void check(char *isalive, char *outboard, char *inboard, int nrows, int ncols, int i, int j, int (*mod)(int, int), char (*alivep)(char, char)) {
//                     const int LDA = nrows;
//                     const int inorth = mod (i-1, nrows);
//                     const int isouth = mod (i+1, nrows);
//                     const int jwest = mod (j-1, ncols);
//                     const int jeast = mod (j+1, ncols);

//                     const char neighbor_count = 
//                         BOARD (inboard, inorth, jwest) + 
//                         BOARD (inboard, inorth, j) + 
//                         BOARD (inboard, inorth, jeast) + 
//                         BOARD (inboard, i, jwest) +
//                         BOARD (inboard, i, jeast) + 
//                         BOARD (inboard, isouth, jwest) +
//                         BOARD (inboard, isouth, j) + 
//                         BOARD (inboard, isouth, jeast);

//                     BOARD(outboard, i, j) = alivep (neighbor_count, BOARD (inboard, i, j));
// }

__device__ int d_mod_v2 (int x, int m)
{
  return (x < 0) ? ((x % m) + m) : (x % m);
}

__device__ char d_alivep_v2 (char count, char state)
{
  return (! state && (count == (char) 3)) ||
    (state && (count >= 2) && (count <= 3));
}

__global__ void GPUInnerLoop_v2(char *outboard, char *inboard, int nrows, int ncols) 
{
   //calculates unique thread ID in the block
  //  int t= (blockDim.x*blockDim.y)*threadIdx.z+    (threadIdx.y*blockDim.x)+(threadIdx.x); 
   
  //  //calculates unique block ID in the grid
  //  int b= (gridDim.x*gridDim.y)*blockIdx.z+(blockIdx.y*gridDim.x)+(blockIdx.x);
   
  //  //block size (this is redundant though)
  //  int T= blockDim.x*blockDim.y*blockDim.z;
   
  //  //grid size (this is redundant though)
  //  int B= gridDim.x*gridDim.y*gridDim.z;
   
   
   /*
   * Each cell in the matrix is assigned to a different thread.
   * Each thread do O(number of asssigned cell) computation.
   * Assigned cells of different threads does not overlape with
   * each other. And so no need for synchronization.
   */
  //printf("thread Idx x y z is:\t%d\t%d\t%d\n", threadIdx.x, threadIdx.y, threadIdx.z);
  //printf("block dimision x y z is:%d\t%d\t%d\n", blockDim.x, blockDim.y, blockDim.z);
  for (int i = threadIdx.x; i < nrows; i += blockDim.x)
  {
    for (int j = threadIdx.y; j < ncols; j+= blockDim.y)
    {
      
        //revise mod and alivep
                const int LDA = nrows;
                
                const int inorth = d_mod_v2 (i-1, nrows);
                const int isouth = d_mod_v2 (i+1, nrows);
                const int jwest = d_mod_v2 (j-1, ncols);
                const int jeast = d_mod_v2 (j+1, ncols);

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
                BOARD(outboard, i, j) = d_alivep_v2 (neighbor_count, BOARD (inboard, i, j));

    }
  }
}


char* cuda_v2_game_of_life (
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
    for (curgen = 0; curgen < gens_max; curgen++)
    {
        GPUInnerLoop_v2<<<dim3(1,1,1), dim3(32, 32,1)>>>(d_outboard, d_inboard, nrows, ncols);
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
