#!/bin/bash
# 2013-05-28: Derek Gottlieb (asndbg)
# 
# Calculate OFED registerable memory limit via the size of the memory
# translation table (MTT) used to map virtual to physical addresses.
#
# Based on equations in the following FAQ entry from OpenMPI:
# http://www.open-mpi.org/faq/?category=openfabrics#ib-low-reg-mem

PAGE_SIZE=$(getconf PAGE_SIZE)

MLX4_LOADED=$(lsmod | grep mlx4_core | wc -l)

if [ "$MLX4_LOADED" -gt 0 ]; then
 echo "mlx4_core module loaded..."
 LOG_NUM_MTT=$(cat /sys/module/mlx4_core/parameters/log_num_mtt)
 LOG_MTTS_PER_SEG=$(cat /sys/module/mlx4_core/parameters/log_mtts_per_seg)

 echo "max_reg = (2^log_num_mtt) * (2^log_mtts_per_seg) * PAGE_SIZE"
 echo "max_reg = (2^${LOG_NUM_MTT}) * (2^${LOG_MTTS_PER_SEG}) * ${PAGE_SIZE}"

 MAX_REG=$(((1<<${LOG_NUM_MTT})*(1<<${LOG_MTTS_PER_SEG})*${PAGE_SIZE}))

 echo "max_reg = ${MAX_REG}"
else
 IB_MTHCA_LOADED=$(lsmod | grep ib_mthca | wc -l)
 if [ "$IB_MTHCA_LOADED" -gt 0 ]; then
  echo "ib_mthca module loaded..."
  echo "max_reg_mem = num_mtt * (2^log_mtts_per_seg) * PAGE_SIZE"
  echo "OR max_reg_mem = (num_mtt - fmr_reserved_mtts) * (2^log_mtts_per_seg) * PAGE_SIZE ?"
  echo "TODO: support old IB hardware..." 
 fi
fi
