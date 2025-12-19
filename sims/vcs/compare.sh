#!/bin/bash

source ./env.sh

RTL_DUMP=$1
SPIKE_DUMP=$2

RTL_CSV=$RTL_DUMP.csv
SPIKE_CSV=$SPIKE_DUMP.csv

python3 $RISCV_DV_DIR/scripts/rocket_log_to_trace_csv.py --log $RTL_DUMP --csv $RTL_CSV --rv32
python3 $RISCV_DV_DIR/scripts/spike_log_to_trace_csv.py --log $SPIKE_DUMP --csv $SPIKE_CSV -f
python3 $RISCV_DV_DIR/scripts/instr_trace_compare.py --csv_file_1 $RTL_CSV --csv_file_2 $SPIKE_CSV 