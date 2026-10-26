#!/bin/bash
# Usage: run_harness.sh TAG PER_TYPE NRAND file.s ...   (x86 agent real-CPU harness)
set -e
D=$(cd "$(dirname "$0")" && pwd)
TAG=$1 PT=$2 NR=$3; shift 3
B=$D/build/$TAG; mkdir -p $D/build
python3 $D/src/gen_harness.py $B "$@"
gcc -O2 -Wall -DPROGS_H="\"$B.h\"" -o $B.bin $D/src/driver.c $B.S
$B.bin $PT $NR
