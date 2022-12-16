
# Parallelization of Conway's Game of Life
This is the parallelization of the Conway's Game of Life. OpenMP and CUDA are used for implementation of the algorithm for calculating states in the Conway's Game of Life.

# How to Run the Program
```
make
./gol 100 inputs/1k.pbm outputs/1k.pbm -v1 -n4
```
Here 100 means the number of generations; the inputs/1k.pbm is the input file's path; the outputs/1k.pbm is the output file's path; the v1 means the the index of the implementation techinques; the -n4 specifies the number of threads that are going to be used.

If you want to genrate new initial boards, do this:
```
initboard <num_rows> <num_cols> > <generated_file_name>
```

# Usage Information
```
Usage: gol ngenerations input_path [output_path] [-v version_of_implementation] [-n nthreads] [-x x_dimension_of_CUDA_blocks] [-y y_dimension_of_CUDA_blocks] [-t time_stat_output_path] [-p plot_type]
``` 

# Implementation Versions
0: the sequential version

1: OpenMP horizontal division

2: OpenMp vertical division

3: CUDA restrict to one block & swap data between host memory and device memory each itertation

4: CUDA restrict to one block

5: CUDA normal
