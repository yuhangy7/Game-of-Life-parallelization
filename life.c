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


char*
game_of_life (char* outboard, 
	      char* inboard,
	      const int nrows,
	      const int ncols,
	      const int gens_max,
		  const int version,
		  const int num_threads)
{
	if (version == SEQUENTIAL) {
		printf("seq");
		return sequential_game_of_life (outboard, inboard, nrows, ncols, gens_max);
	} else if (version == OPENMP_DEVIDE_BY_ROW) {
		printf("para row");
		return parallel_game_of_life(outboard, inboard, nrows, ncols, gens_max, num_threads);
	} else if (version == OPENMP_DEVIDE_BY_COL) {
		printf("para col");
		return parallel_game_of_life(outboard, inboard, nrows, ncols, gens_max, num_threads);
	}
}
