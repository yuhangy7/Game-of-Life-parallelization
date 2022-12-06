#
# Include platform-dependent settings, and definitions.
#
include Makefile.include
CFLAGS += -fopenmp 
LDFLAGS += -lm -pthread
CPPFLAGS += "-DCOMPILER=\"$(CC)\"" "-DFLAGS=\"$(COPTFLAGS)\""

#
# Include the realtime clock library, if required.
#
ifeq ($(TIMER_TYPE),USE_CLOCK_GETTIME_REALTIME)
	LDFLAGS += -lrt
else
	ifeq ($(TIMER_TYPE),USE_CLOCK_GETTIME_MONOTONIC)
		LDFLAGS += -lrt
	endif
endif

GOL_EXE = gol
GOL_VERIFY_EXE = gol_verify
GOL_OBJS = gol.o life.o lifeseq.o lifepara.o load.o save.o 
CUDA_OBJS = lifecudapara.o lifecudapara_v2.o lifecudapara_v3.o 
GOL_VERIFY_OBJS = gol.verify.o life.o lifeseq.o lifepara.o load.o save.o 
BITBOARD_EXE = initboard
BITBOARD_OBJS = bitboard.o random_bit.o
EXES = $(GOL_EXE) $(BITBOARD_EXE)
OBJS = $(GOL_OBJS) $(BITBOARD_OBJS)


all: $(GOL_EXE) $(BITBOARD_EXE)

$(GOL_EXE): $(GOL_OBJS) $(CUDA_OBJS)
	$(CXX) $(CFLAGS) $(LDFLAGS) $(GOL_OBJS) $(CUDA_OBJS) -L/usr/local/cuda/lib64 -lcudart -o $@ 

$(GOL_VERIFY_EXE): $(GOL_VERIFY_OBJS) 
	$(CXX) $(CFLAGS) $(LDFLAGS) $(GOL_VERIFY_OBJS) -o $@ 

$(BITBOARD_EXE): $(BITBOARD_OBJS)
	$(CXX) $(CFLAGS) $(LDFLAGS) $(BITBOARD_OBJS) -o $@ 

%.o: %.cpp
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o: %.cu
	nvcc -c $< -o $@

%.verify.o: %.cpp
	$(CXX) -c $(CFLAGS) -DVERIFY_FLAG $(CPPFLAGS) $< -o $@

lifeseq.o: lifeseq.cpp life.h util.h

lifepara.o: lifepara.cpp life.h util.h

life.o: life.cpp life.h util.h

load.o: load.cpp load.h

save.o: save.cpp save.h

gol.o: gol.cpp life.h load.h save.h 

bitboard.o: bitboard.cpp random_bit.h

random_bit.o: random_bit.cpp random_bit.h

vector_add.o: vector_add.cu

lifecudapara.o : lifecudapara.cu

lifecudapara_v2.o : lifecudapara_v2.cu

lifecudapara_v3.o : lifecudapara_v3.cu

clean:
	rm -f $(GOL_OBJS) $(GOL_VERIFY_OBJS) $(GOL_EXE) $(GOL_VERIFY_EXE) $(BITBOARD_OBJS) $(BITBOARD_EXE) 
