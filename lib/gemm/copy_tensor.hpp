#pragma once

#include <cute/tensor.hpp>

#include <cutlass/cutlass.h>

#include "cute/arch/cluster_sm90.hpp"

using namespace cute;

namespace cfk {
template <typename SrcEngine, typename SrcLayout, typename DstEngine,
          typename DstLayout, typename AtomX, class... ArgsX>
__device__ void copy(Tensor<SrcEngine, SrcLayout> const &gX,
                     Tensor<DstEngine, DstLayout> &&sX,
                     TiledCopy<AtomX, ArgsX...> const &tma_load_x,
                     uint64_t *tma_load_mbar, uint16_t mcast_mask_a = 0) {
  using SrcType = typename AtomX::ValType;
  // Set the bytes transferred in this TMX transaction (may involve multiple
  // issues)
  constexpr int kTmaTransactionBytes =
      size(SrcLayout{}) * sizeof_bits_v<SrcType> / 8;

  if (threadIdx.x == 0) {
    /// Initialize shared memory barrier
    tma_load_mbar[0] = 0;
    cute::initialize_barrier(tma_load_mbar[0], 1 /*numThreads*/);
    cute::set_barrier_transaction_bytes(tma_load_mbar[0], kTmaTransactionBytes);

    copy(tma_load_x.with(tma_load_mbar[0]), gX, sX);
  }
  __syncthreads();

  /// Wait on the shared memory barrier until the phase bit flips from
  /// kPhaseBit value
  constexpr int kPhaseBit = 0;
  cute::wait_barrier(tma_load_mbar[0], kPhaseBit);

  __syncthreads();
}

template <typename SrcEngineA, typename SrcLayoutA, typename SrcEngineB,
          typename SrcLayoutB, typename DstEngineA, typename DstLayoutA,
          typename DstEngineB, typename DstLayoutB, typename AtomA,
          class... ArgsA, typename AtomB, class... ArgsB>
__device__ void
copy(Tensor<SrcEngineA, SrcLayoutA> const &gA,
     Tensor<SrcEngineB, SrcLayoutB> const &gB,
     Tensor<DstEngineA, DstLayoutA> &&sA, Tensor<DstEngineB, DstLayoutB> &&sB,
     TiledCopy<AtomA, ArgsA...> const &tma_load_a,
     TiledCopy<AtomB, ArgsB...> const &tma_load_b, uint64_t *tma_load_mbar,
     uint16_t mcast_mask_a = 0, uint16_t mcast_mask_b = 0) {

  using SrcTypeA = typename AtomA::ValType;
  using SrcTypeB = typename AtomB::ValType;
  // Set the bytes transferred in this TMX transaction (may involve multiple
  // issues)
  constexpr int kTmaTransactionBytes =
      size(SrcLayoutA{}) * sizeof_bits_v<SrcTypeA> / 8 +
      size(SrcLayoutB{}) * sizeof_bits_v<SrcTypeB> / 8;

  if (threadIdx.x == 0) {
    /// Initialize shared memory barrier
    tma_load_mbar[0] = 0;
    cute::initialize_barrier(tma_load_mbar[0], 1 /*numThreads*/);
    cute::set_barrier_transaction_bytes(tma_load_mbar[0], kTmaTransactionBytes);

    copy(tma_load_a.with(tma_load_mbar[0], mcast_mask_a), gA, sA);
    copy(tma_load_b.with(tma_load_mbar[0], mcast_mask_b), gB, sB);
  }
  __syncthreads();

  /// Wait on the shared memory barrier until the phase bit flips from
  /// kPhaseBit value
  constexpr int kPhaseBit = 0;
  cute::wait_barrier(tma_load_mbar[0], kPhaseBit);

  __syncthreads();
}
} // namespace cfk
