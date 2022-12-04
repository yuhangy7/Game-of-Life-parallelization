/*****************************************************************************
 * life.c
 * OpenMp version of parallel code.
 ****************************************************************************/
#include "life.h"
#include "util.h"
#include <stdio.h>
#include <omp.h>
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


    char*
parallel_game_of_life (char* outboard, 
        char* inboard,
        const int nrows,
        const int ncols,
        const int gens_max,
        const int version,
        const int num_threads)
{
    /* HINT: in the parallel decomposition, LDA may not be equal to
       nrows! */
    const int LDA = nrows;
    int curgen, i, j;
    omp_set_dynamic(0);
    omp_set_num_threads(num_threads);
    //printf("number of threads, %d\n",num_threads);
    printf("current version is: %d\n", version);
    if (version == 1) {
    for (curgen = 0; curgen < gens_max; curgen++)
        {
            /* HINT: you'll be parallelizing these loop(s) by doing a
            geometric decomposition of the output */
            #pragma omp parallel for
            for (i = 0; i < nrows; i++)
            {   //printf("number of threads, %d\n",omp_get_num_threads());
                for (j = 0; j < ncols; j++)
                {
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
            SWAP_BOARDS( outboard, inboard );

        }
    } else if (version == 2){
    for (curgen = 0; curgen < gens_max; curgen++)
        {
            /* HINT: you'll be parallelizing these loop(s) by doing a
            geometric decomposition of the output */
            for (i = 0; i < nrows; i++)
            {   //printf("number of threads, %d\n",omp_get_num_threads());
                #pragma omp parallel for
                for (j = 0; j < ncols; j++)
                {
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
            SWAP_BOARDS( outboard, inboard );
        }
    }
    
    /* 
     * We return the output board, so that we know which one contains
     * the final result (because we've been swapping boards around).
     * Just be careful when you free() the two boards, so that you don't
     * free the same one twice!!! 
     */
    return inboard;
}


