#include "life.h"
#include "util.h"
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>

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
__global__ void GPUInnerLoop(char *outboard, char *inboard, int nrows, int ncols, int (*mod)(int, int), char (*alivep)(char, char)) 
{
   //calculates unique thread ID in the block
   int t= (blockDim.x*blockDim.y)*threadIdx.z+    (threadIdx.y*blockDim.x)+(threadIdx.x); 
   
   //calculates unique block ID in the grid
   int b= (gridDim.x*gridDim.y)*blockIdx.z+(blockIdx.y*gridDim.x)+(blockIdx.x);
   
   //block size (this is redundant though)
   int T= blockDim.x*blockDim.y*blockDim.z;
   
   //grid size (this is redundant though)
   int B= gridDim.x*gridDim.y*gridDim.z;
   
   
   /*
   * Each cell in the matrix is assigned to a different thread.
   * Each thread do O(number of asssigned cell) computation.
   * Assigned cells of different threads does not overlape with
   * each other. And so no need for synchronization.
   */
  for (int i = b; i < nrows; i+=B)
  {
    for (int j = t; j < ncols; j+=T)
    {
        //revise mod and alivep
                const int LDA = nrows;
                const int inorth = mod (i-1, nrows);
                const int isouth = mod (i+1, nrows);
                const int jwest = mod (j-1, ncols);
                const int jeast = mod (j+1, ncols);

                const char neighbor_count = 
                    BOARD (inboard, inorth, jwest) + 
                    BOARD (inboard, inorth, j) + 
                    BOARD (inboard, inorth, jeast) + 
                    BOARD (inboard, i, jwest) +
                    BOARD (inboard, i, jeast) + 
                    BOARD (inboard, isouth, jwest) +
                    BOARD (inboard, isouth, j) + 
                    BOARD (inboard, isouth, jeast);

                BOARD(outboard, i, j) = alivep (neighbor_count, BOARD (inboard, i, j));

    }
  }
}


char* cuda_game_of_life (
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
    //printf("number of threads, %d\n",num_threads);
    printf("current version is: %d\n", version);
    
    for (curgen = 0; curgen < gens_max; curgen++)
    {
            /* HINT: you'll be parallelizing these loop(s) by doing a
            geometric decomposition of the output */
            
            // for (i = 0; i < nrows; i++)
            // {   //printf("number of threads, %d\n",omp_get_num_threads());
            //     for (j = 0; j < ncols; j++)
            //     {   char isalive;
            //         char *isalivePtr = &isalive;
            //         check<<<1, 1>>>(isalivePtr, outboard, inboard, nrows, ncols, i, j, &mod, &alivep);
            //         BOARD(outboard, i, j) = *isalivePtr;
            //     }
            // }
            char * d_inboard;
            char * d_outboard;
            char * d_checkboard;
            cudaMalloc(&d_inboard, sizeof(char) * nrows * ncols);
            cudaMalloc(&d_outboard, sizeof(char) * nrows * ncols);
            cudaMalloc(&d_checkboard, sizeof(char) * nrows * ncols);
            cudaMemcpy(d_inboard, inboard, sizeof(char) * nrows * ncols, cudaMemcpyHostToDevice);
            GPUInnerLoop<<<1, 1>>>(outboard, inboard, nrows, ncols, &mod, &alivep);
            cudaMemcpy(outboard, d_outboard, sizeof(char) * nrows * ncols, cudaMemcpyDeviceToHost);
            SWAP_BOARDS( outboard, inboard );



            
            // char* final_board = cuda_game_of_life<<<1,512>>> (outboard, inboard, nrows, ncols, gens_max);
            
            // return final_board;
    }
    
    
 
    
    /* 
    * We return the output board, so that we know which one contains
    * the final result (because we've been swapping boards around).
    * Just be careful when you free() the two boards, so that you don't
    * free the same one twice!!! 
    */
    return inboard;
}
