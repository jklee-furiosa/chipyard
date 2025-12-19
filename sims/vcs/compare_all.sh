#!/bin/bash

ASM_DIR=$1
LOG_DIR=$2

SPIKE_LOG_DIR=$ASM_DIR/../spike_sim

if [[ ! -d "$SPIKE_LOG_DIR" ]]; then
  echo "Directory not found: $ASM_DIR" >&2
  exit 1
fi

# Collect test objects
mapfile -d '' OBJS < <(find "$ASM_DIR" -maxdepth 1 -type f -name '*.o' -print0 | sort -z)

pass_status=0
RESULTS=()
for obj in "${OBJS[@]}"; do
  base="$(basename "${obj%.o}")"
  rocket_log="${LOG_DIR}/${base}.out"
  spike_log="${SPIKE_LOG_DIR}/${base}.log"

  ./compare.sh $rocket_log $spike_log > ${LOG_DIR}/compare_${base}.log

  if grep -q "PASSED" "${LOG_DIR}/compare_${base}.log"; then
    RESULTS+=("[PASS] $base")
  else
    RESULTS+=("[FAIL] $base (missing PASSED in ${LOG_DIR}/compare_${base}.log)")
    pass_status=1
  fi
done

echo "---- Summary ----"
for r in "${RESULTS[@]}"; do
  echo "$r"
done

if [ $pass_status -ne 0 ]; then
  exit 1
fi