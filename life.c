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
	      const int gens_max,
		  const int version)
{
	if (version == 0) {
		return sequential_game_of_life (outboard, inboard, nrows, ncols, gens_max);
	} else if (version == 1) {
		return parallel_game_of_life(outboard, inboard, nrows, ncols, gens_max);
	}
}
