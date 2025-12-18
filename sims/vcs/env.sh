#!/bin/bash
source /nfs/tools/asic/stork_dv.env

CHIPYARD_DIR=$(dirname $(readlink -f $0))

export CONDA_PATH=/root/miniconda3/bin
export RISCV=$CHIPYARD_DIR/.conda-env/riscv-tools
export RISCV_GCC=$RISCV/bin/riscv64-unknown-elf-gcc
export RISCV_OBJCOPY=$RISCV/bin/riscv64-unknown-elf-objcopy
export SPIKE_PATH=$RISCV/bin

export PATH=$CONDA_PATH:$PATH


PATH=$CHIPYARD_DIR/software/firemarshal:$PATH

if ! type conda >& /dev/null; then
    echo "::ERROR:: you must have conda in your environment first"
    return 1  # don't want to exit here because this file is sourced
fi

source $(conda info --base)/etc/profile.d/conda.sh
conda activate $CHIPYARD_DIR/.conda-env
source $CHIPYARD_DIR/scripts/fix-open-files.sh
# >>> cy-dir-helper initialize >>>
CY_DIR=/root/workspace/chipyard
# <<< cy-dir-helper initialize <<<

