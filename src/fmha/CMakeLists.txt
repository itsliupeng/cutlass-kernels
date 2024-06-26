set(CMAKE_CUDA_ARCHITECTURES 90) 
cmake_minimum_required(VERSION 3.28 FATAL_ERROR)
project(fmha LANGUAGES CXX CUDA)

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
# set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O0 -g -G")
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O0 -g -lineinfo --expt-relaxed-constexpr --use_fast_math")

# Include directories
set(CUTLASS_DIR /cpfs/data/shared/public/liupeng/code/cutlass-kernels/cutlass)
include_directories(
    ${CUTLASS_DIR}/include
    ${CUTLASS_DIR}/examples/common
    ${CUTLASS_DIR}/tools/util/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../../lib
    ${CMAKE_CURRENT_SOURCE_DIR}/../../include
)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Executable
add_executable(main fmha_forward.cu)
# target_link_libraries(main PUBLIC vllm_flash_attn_2_cuda)
