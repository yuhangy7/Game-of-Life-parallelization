/*****************************************************************************
 * life.c
 * The original sequential implementation resides here.
 * Do not modify this file, but you are encouraged to borrow from it
 ****************************************************************************/
#include "life.h"
#include "util.h"

/**
 * Swapping the two boards only involves swapping pointers, not
 * copying values.
 */
#define SWAP_BOARDS( b1, b2 )  do { \
  char* temp = b1; \
  b1 = b2; \
  b2 = temp; \
} while(0)

#define BOARD( __board, __i, __j )  (__board[(__i) + LDA*(__j)])


__global__
void GPUInnerLoops(char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols)
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
  for (i = b; i < nrows; i+=B)
  {
    for (j = t; j < ncols; j+=T)
    {
        //revise mod and alivep
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


char*
cuda_game_of_life (char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols,
        const int gens_max)
{
    /* HINT: in the parallel decomposition, LDA may not be equal to
       nrows! */
    const int LDA = nrows;
    int curgen, i, j;

    for (curgen = 0; curgen < gens_max; curgen++)
    {
        /* HINT: you'll be parallelizing these loop(s) by doing a
           geometric decomposition of the output */
        GPUinnerloop(outboard, inboard, nrows, ncols)
        SWAP_BOARDS( outboard, inboard );

    }
    /* 
     * We return the output board, so that we know which one contains
     * the final result (because we've been swapping boards around).
     * Just be careful when you free() the two boards, so that you don't
     * free the same one twice!!! 
     */
    return inboard;
}


