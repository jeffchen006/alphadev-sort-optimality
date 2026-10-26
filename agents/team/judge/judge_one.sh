#!/bin/bash
# Usage: judge_one.sh F_out.s [iset]  -> one line: file k L judge_out judge_mem x86 MM1
T=/path/to/repo; cd $T
F=$1; IS=${2:-I1}; D=agents/team/judge; B=$(basename $F .s)
python3 $D/out2mem.py $F $D/${B}_mem.s $IS || { echo "$F CONVERT-FAIL"; exit 1; }
K=$(grep -cE '^(mov|cmp|cmov)' $F); L=$(grep -cE '^(mov|cmp|cmov)' $D/${B}_mem.s)
MM=$(grep -E "^(cmp|cmov)" $D/${B}_mem.s | grep -cE "\bP[0-9]")
JO=$(python3 shared/judge.py $F --strict --model out --iset $IS -q 2>&1 | grep -E '^(PASS|FAIL)' | cut -c1-4 | head -1)
JM=$(python3 shared/judge.py $D/${B}_mem.s --strict --model mem --iset $IS -q 2>&1 | grep -E '^(PASS|FAIL)' | cut -c1-4 | head -1)
X=$(agents/x86/run_harness.sh j_$B 1000 100000 $D/${B}_mem.s 2>&1 | grep -c 'SORTS(strict)')
echo "$F k=$K L=$L out=$JO mem=$JM x86=$X/3 MMviol=$MM"
