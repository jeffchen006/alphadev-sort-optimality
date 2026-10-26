#!/bin/bash
# CLAIM (spec, theory): Lemma 4.1 / L5 construction, two independent implementations (spec ad2out.py, theory l5map.py):
# every published memory-model kernel (n<=5) maps to an M_out program with k <= L - 2n that is strict-correct.
# Expected: "k<=L-2n OK" for each file, every judge line PASS. Time ~2 min, 1 core.
source "$(dirname "$0")/../lib.sh"
P=$SRC/programs
for f in $(grep -l "model=mem " $P/*.s $P/orig/alphadev_sort[345]_*.s $P/found/*.s); do
  b=$OUT/$(basename $f .s)
  PYTHONPATH=$SRC/shared python3 $SRC/spec/ad2out.py $f > $b.spec_out.s 2> $b.err; say "ad2out $(basename $f): $(cat $b.err)"
  run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py $b.spec_out.s --strict -q
  PYTHONPATH=$SRC/shared python3 $SRC/theory/l5map.py $f > $b.theory_out.s 2>> $LOG && run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py $b.theory_out.s --strict --model out -q
done
grep -q "VIOLATES\|^FAIL" "$LOG" && { say "violation or FAIL"; FAILS=$((FAILS+1)); }
expect "ad2out alphadev_sort3_17_repo.s: k=11 L=17 L-2n=11 OK"
finish
