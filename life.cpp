/*****************************************************************************
 * life.c
 * Parallelized and optimized implementation of the game of life resides here
 ****************************************************************************/
#include "life.h"
#include "util.h"
#include <stdio.h>
/*****************************************************************************
 * Helper function definitions
 ****************************************************************************/

/*****************************************************************************
 * Game of life implementation
 ****************************************************************************/
#define SEQUENTIAL 0
#define OPENMP_DEVIDE_BY_ROW 1
#define OPENMP_DEVIDE_BY_COL 2
#define CUDA_V1 3
#define CUDA_V2 4
#define CUDA_V3 5


char*
game_of_life (char* outboard, 
	      char* inboard,
	      const int nrows,
	      const int ncols,
	      const int gens_max,
		  const int version,
		  const int num_threads,
		  const int num_threads_in_a_block_x,
		  const int num_threads_in_a_block_y)
{
	if (version == SEQUENTIAL) {
		printf("seq");
		return sequential_game_of_life (outboard, inboard, nrows, ncols, gens_max);
	} else if (version == OPENMP_DEVIDE_BY_ROW) {
		printf("para row");
		return parallel_game_of_life(outboard, inboard, nrows, ncols, gens_max, version, num_threads);
	} else if (version == OPENMP_DEVIDE_BY_COL) {
		printf("para col");
		return parallel_game_of_life(outboard, inboard, nrows, ncols, gens_max, version, num_threads);
	} else if (version == CUDA_V1) {
		printf("cuda_v1 version\n");
		return cuda_v1_game_of_life(outboard, inboard, nrows, ncols, gens_max, version, num_threads, num_threads_in_a_block_x, num_threads_in_a_block_y);
	} else if (version == CUDA_V2) {
		printf("cuda_v2 version\n");
		return cuda_v2_game_of_life(outboard, inboard, nrows, ncols, gens_max, version, num_threads, num_threads_in_a_block_x, num_threads_in_a_block_y);
	} else if (version == CUDA_V3) {
		printf("cuda_v3 version\n");
		return cuda_v3_game_of_life(outboard, inboard, nrows, ncols, gens_max, version, num_threads, num_threads_in_a_block_x, num_threads_in_a_block_y);
	}
}
