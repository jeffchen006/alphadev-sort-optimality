#!/bin/bash
# CLAIM (spec, x86, lean): AlphaDev sort3 (L=17, repo + SI), the human network (18) and every n=3 witness are correct in the
# strict model; their M_out cores have k = 11 (upper bound k_out(3) <= 11, L_AD(3) <= 17).
# Expected: every line PASS. Time ~20 s, 1 core.
source "$(dirname "$0")/../lib.sh"
P=$SRC/programs
for f in $P/alphadev_sort3.s $P/orig/alphadev_sort3_*.s $P/human_sort3.s $P/variants/tunney_sort3_17.s; do
  run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py $f --strict -q; done
for f in $P/out/alphadev_sort3_*_out.s $P/found/*sort3*.s; do   # model taken from each file header
  run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py $f --strict -q; done
expect "PASS .*alphadev_sort3.s .*L=17"
expect "PASS .*alphadev_sort3_17_repo_out.s .*L=11"
expect "PASS .*enum_sort3_out_I1_k11.s"
grep -q "^FAIL" "$LOG" && { say "a program FAILED"; FAILS=$((FAILS+1)); }
finish
