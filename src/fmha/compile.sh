/usr/local/cuda/bin/nvcc --use_fast_math -forward-unknown-to-host-compiler \
-I../../lib/ \
-I ../../include \
-I/cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass/include \
-I/cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass/examples/common \
-I/cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass/tools/util/include \
-I"/usr/local/cuda/include" \
-I/include -I/examples \
-O3 -DNDEBUG --generate-code=arch=compute_90a,code=[sm_90a]  \
-Xcompiler=-fPIE -DCUTLASS_ENABLE_TENSOR_CORE_MMA=1  \
--expt-extended-lambda --expt-relaxed-constexpr \
-DCUTLASS_TEST_LEVEL=0 -DCUTLASS_TEST_ENABLE_CACHED_RESULTS=1 \
-DCUTLASS_CONV_UNIT_TEST_RIGOROUS_SIZE_ENABLED=1 -DCUTLASS_DEBUG_TRACE_LEVEL=0 \
-Xcompiler=-Wno-psabi -Xcompiler=-fno-strict-aliasing  -Xnvlink=--verbose -Xptxas=--verbose \
-std=c++17 -MD -MT -MF -x cu  \
fmha_forward.cu \
-Wl,-rpath,'/usr/local/cuda/lib64' -Wl,-rpath,'/usr/local/cuda/lib' \
-lcuda  -lcudadevrt -lcudart_static -lcublas -lrt -lpthread -ldl -o fmha_forward $1 $2 $3 $4 $5 $6