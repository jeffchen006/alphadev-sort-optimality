#!/bin/bash
# CLAIMS (upper): (a) a seeded, iteration-limited MCMC search re-finds k=11 (n=3) and k=20 (n=4) M_out programs from
# scratch (upper bounds = AlphaDev's cores); (b) upper's sort4/sort5 upper-bound kernels are strict-correct:
# sort5 k=32 / L=42 in I0 and I1 (AlphaDev model), and §1 fixed-output kernels (NOT AlphaDev bounds): sort3 11, sort4 20, sort5 33.
# Expected: "FOUND len=11", "FOUND len=20" (upper: it=14532 / it=154361 on this CPU; may differ with another libm), all PASS.
# Time ~40 s + judge, 1 core.
source "$(dirname "$0")/../lib.sh"
run gcc -O3 -w -o $OUT/mcmc $SRC/upper/src/mcmc.c -lm
run $OUT/mcmc -n 3 -m out -L 14 -S 2 -i I1 -T 0.2 -restart 0.000001 -seed 1 -iters 3000000 -time 1e9 -out $OUT/u3
run $OUT/mcmc -n 4 -m out -L 24 -S 3 -i I1 -T 0.3 -restart 0.0000005 -seed 4 -iters 20000000 -time 1e9 -out $OUT/u4
expect "FOUND len=11"
expect "FOUND len=20"
J="env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py"
for f in $OUT/u3_len11_*.s $OUT/u4_len20_*.s; do run $J $f --strict --model out -q; done
F=$SRC/programs/found
run $J $F/upper_sort5_I0_k32_out.s --strict --model out --iset I0 -q
run $J $F/upper_sort5_I0_L42_mem.s --strict --model mem --iset I0 -q
run $J $F/upper_sort5_I1_k32_out.s --strict --model out -q
run $J $F/upper_sort5_I1_L42_mem.s --strict --model mem -q
say "-- §1 fixed-output upper bounds (NOT AlphaDev bounds):"
for f in upper_sort5_reg_k33.s upper_sort4_reg_k20.s upper_sort3_reg_I0_k11.s; do run $J $F/$f --strict --model reg -q; done
grep -q "^FAIL" $LOG && { say "a program FAILED"; FAILS=$((FAILS+1)); }
finish
