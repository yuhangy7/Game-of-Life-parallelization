/*****************************************************************************
 * life.c
 * Parallelized and optimized implementation of the game of life resides here
 ****************************************************************************/
#include "life.h"
#include "util.h"

/*****************************************************************************
 * Helper function definitions
 ****************************************************************************/

/*****************************************************************************
 * Game of life implementation
 ****************************************************************************/
char*
game_of_life (char* outboard, 
	      char* inboard,
	      const int nrows,
	      const int ncols,
	      const int gens_max)
{
  cudaMalloc(&d_inboard, sizeof(char) * nrows * ncols);
  cudaMalloc(&d_outboard, sizeof(char) * nrows * ncols);
  cudaMalloc(&d_checkboard, sizeof(char) * nrows * ncols);
  cudaMemcpy(d_inboard, inboard, sizeof(char) * nrows * ncols, cudaMemcpyHostToDevice);
  char* final_board = cuda_game_of_life<<<1,512>>> (outboard, inboard, nrows, ncols, gens_max);
  cudaMemcpy(outboard, d_outboard, sizeof(char) * nrows * ncols, cudaMemcpyDeviceToHost);
  return final_board;
}
