#!/bin/bash
# CLAIM (spec, x86): the judge semantics equals real x86-64 (edge cases: cmp/cmovl/le/g/ge on INT_MIN..INT_MAX x all
# initial flag states via popfq), and every model=mem program in programs/ sorts on this CPU in the strict model
# (garbage in all scratch registers, random flags), memory and all registers equal to the judge.
# Expected: "EDGE PASS: 1600 cases, 0 mismatches"; every program line PASS. Time ~5 min (TESTS=20000), 1 core.
# The x86 agent's own, larger harness: agents/x86/run_harness.sh (REPORT.md).
source "$(dirname "$0")/../lib.sh"
X=$OUT/xdiff; mkdir -p $X; cp $SRC/spec/xdiff.py $X/   # spec's harness (builds C files under $X/build)
run env PYTHONPATH=$SRC/shared python3 $X/xdiff.py --edge
for f in $SRC/programs/alphadev_sort*.s $SRC/programs/human_sort*.s $SRC/programs/orig/alphadev_sort[345]_*.s; do
  run env PYTHONPATH=$SRC/shared python3 $X/xdiff.py $f --tests ${TESTS:-20000}
done
expect "EDGE PASS: 1600 cases, 0 mismatches"
grep -q "^FAIL\|SEMANTICS MISMATCH" $LOG && { say "FAIL or mismatch"; FAILS=$((FAILS+1)); }
finish
