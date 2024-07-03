set(CMAKE_CUDA_ARCHITECTURES 90a) 
cmake_minimum_required(VERSION 3.29 FATAL_ERROR)
project(fmha_fp8 LANGUAGES CXX CUDA)

set(CMAKE_CUDA_COMPILER /usr/local/cuda/bin/nvcc)
# Set the C++ standard to use
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Compiler options
add_compile_options(-Wno-deprecated-declarations)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Debug build settings
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_STREAM_DEBUG} -g")

# CUDA options
# Set CUDA standard
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
# set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} --expt-relaxed-constexpr --use_fast_math -t 8 \
#                       -gencode arch=compute_80,code=sm_80")

# set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -g -G --expt-relaxed-constexpr --use_fast_math -t 8")
# set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O0 -g -G") # lineinfo
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O0 -g -G --expt-relaxed-constexpr --use_fast_math --generate-code=arch=compute_90a,code=[sm_90a]")
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} --expt-extended-lambda --expt-relaxed-constexpr -Xcompiler=-Wno-psabi -Xcompiler=-fno-strict-aliasing")  # -Xnvlink=--verbose -Xptxas=--verbose

# 添加宏定义
add_definitions(-DCUTLASS_ENABLE_TENSOR_CORE_MMA=1)
add_definitions(-DCUTLASS_TEST_LEVEL=0 -DCUTLASS_TEST_ENABLE_CACHED_RESULTS=1)
add_definitions(-DCUTLASS_CONV_UNIT_TEST_RIGOROUS_SIZE_ENABLED=1 -DCUTLASS_DEBUG_TRACE_LEVEL=0)
# add_definitions(-DGEMM2FP8 -DQBLKSIZE=64 -DKBLKSIZE=128 -DCLUSTERN=2 -DQINRMEM)
add_definitions(-DGEMM2FP8 -DQBLKSIZE=64 -DKBLKSIZE=64 -DCLUSTERN=1 -DQINRMEM)

# Include directories
set(CUTLASS_DIR /cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass)
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/../../lib
    ${CMAKE_CURRENT_SOURCE_DIR}/../../include
    ${CUTLASS_DIR}/include
    ${CUTLASS_DIR}/tools/util/include
    ${CUTLASS_DIR}/examples/common
)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

message(STATUS "CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")

add_executable(fmha_fp8 fmha_forward.cu)

# 链接库
target_link_libraries(fmha_fp8 
  cuda cudadevrt cudart_static cublas rt pthread dl
)
