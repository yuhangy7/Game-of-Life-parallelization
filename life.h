#ifndef _life_h
#define _life_h

/**
 * Given the initial board state in inboard and the board dimensions
 * nrows by ncols, evolve the board state gens_max times by alternating
 * ("ping-ponging") between outboard and inboard.  Return a pointer to 
 * the final board; that pointer will be equal either to outboard or to
 * inboard (but you don't know which).
 */
char*
game_of_life (char* outboard, 
	      char* inboard,
	      const int nrows,
	      const int ncols,
	      const int gens_max,
		  const int version,
		  const int num_threads,
		  const int num_threads_in_a_block_x,
		  const int num_threads_in_a_block_y);

/**
 * Same output as game_of_life() above, except this is not
 * parallelized.  Useful for checking output.
 */
char*
sequential_game_of_life (char* outboard, 
			 char* inboard,
			 const int nrows,
			 const int ncols,
			 const int gens_max);

char*
parallel_game_of_life (char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols,
        const int gens_max,
		const int version,
		const int num_threads);

char*
cuda_v1_game_of_life (char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols,
        const int gens_max,
		const int version,
		const int num_threads,
		const int num_threads_in_a_block_x,
		const int num_threads_in_a_block_y);

char*
cuda_v2_game_of_life (char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols,
        const int gens_max,
		const int version,
		const int num_threads,
		const int num_threads_in_a_block_x,
		const int num_threads_in_a_block_y);

char*
cuda_v3_game_of_life (char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols,
        const int gens_max,
		const int version,
		const int num_threads,
		const int num_threads_in_a_block_x,
		const int num_threads_in_a_block_y);
#endif /* _life_h */
