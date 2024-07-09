# /usr/local/cuda/bin/nvcc --use_fast_math -forward-unknown-to-host-compiler -I../../lib/ -I ../../include  -I/home/colfax/jshah/cutlass-3.4/include -I/home/colfax/jshah/cutlass-3.4/examples/common -I"/usr/local/cuda-12.3/include" -I/include -I/examples -I/home/colfax/jshah/cutlass-3.4/tools/util/include -O3 -DNDEBUG --generate-code=arch=compute_90a,code=[sm_90a]  -Xcompiler=-fPIE -DCUTLASS_ENABLE_TENSOR_CORE_MMA=1  --expt-extended-lambda --expt-relaxed-constexpr -DCUTLASS_TEST_LEVEL=0 -DCUTLASS_TEST_ENABLE_CACHED_RESULTS=1 -DCUTLASS_CONV_UNIT_TEST_RIGOROUS_SIZE_ENABLED=1 -DCUTLASS_DEBUG_TRACE_LEVEL=0 -Xcompiler=-Wno-psabi -Xcompiler=-fno-strict-aliasing -Xnvlink=--verbose -Xptxas=--verbose  -std=c++17 -MD -MT -MF -x cu  fmha_forward.cu -Wl,-rpath,'/usr/local/cuda-12.3/lib64' -Wl,-rpath,'/usr/local/cuda-12.3/lib' -lcuda  -lcudadevrt -lcudart_static -lcublas -lrt -lpthread -ldl -o fmha_forward_fp8 -DGEMM2FP8 -DQBLKSIZE=128 -DKBLKSIZE=128 -DCTA256 -DQINRMEM
/usr/local/cuda/bin/nvcc --use_fast_math -forward-unknown-to-host-compiler \
-I../../lib/ -I ../../include  \
-I/cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass/include \
-I/cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass/examples/common \
-I"/usr/local/cuda/include" \
-I/include -I/examples \
-I/cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass/tools/util/include \
-O3 -DNDEBUG --generate-code=arch=compute_90a,code=[sm_90a]  \
-Xcompiler=-fPIE -DCUTLASS_ENABLE_TENSOR_CORE_MMA=1  --expt-extended-lambda --expt-relaxed-constexpr \
-DCUTLASS_TEST_LEVEL=0 -DCUTLASS_TEST_ENABLE_CACHED_RESULTS=1 -DCUTLASS_CONV_UNIT_TEST_RIGOROUS_SIZE_ENABLED=1 \
-DCUTLASS_DEBUG_TRACE_LEVEL=0 -Xcompiler=-Wno-psabi -Xcompiler=-fno-strict-aliasing \
-Xnvlink=--verbose -Xptxas=--verbose  -std=c++17 -MD -MT -MF -x cu  \
fmha_forward.cu \
-Wl,-rpath,'/usr/local/cuda/lib64' -Wl,-rpath,'/usr/local/cuda/lib' \
-lcuda  -lcudadevrt -lcudart_static -lcublas -lrt -lpthread -ldl \
-o release/mha_forward_fp8_h256_cta256 \
-DGEMM2FP8 -DQBLKSIZE=128 -DKBLKSIZE=64 -DCLUSTERN=2 -DCTA256 -DLP_DEBUG
# -DGEMM2FP8 -DQBLKSIZE=128 -DKBLKSIZE=128 -DCTA256 -DQINRMEM