#!/bin/bash
# x86 agent: full real-CPU run on all team programs with n <= 5, plus judge comparison.
# Usage: run_all.sh PER_TYPE NRAND [JOBS]   -> logs/all_<shard>.log, logs/judge_all.log, logs/x86isa_all.log
set -e
D=$(cd "$(dirname "$0")" && pwd); T=$(cd $D/../.. && pwd)
PT=$1 NR=$2 J=${3:-4}
FILES=$(for f in $T/programs/orig/*.s $T/programs/out/*.s $T/programs/found/*.s $D/programs/*.s $D/programs/mutants/*naiveI0.s; do
  [ -f "$f" ] || continue; n=$(grep -o 'n=[0-9]*' "$f" | head -1 | cut -d= -f2); [ "$n" -le 5 ] && echo "$f"; done)
echo "$FILES" > $D/logs/all_files.txt
i=0; for f in $FILES; do echo $f >> $D/build/shard_$((i % J)).lst.tmp; i=$((i+1)); done
for s in $(seq 0 $((J-1))); do mv $D/build/shard_$s.lst.tmp $D/build/shard_$s.lst; done
for s in $(seq 0 $((J-1))); do
  ( python3 $D/src/gen_harness.py $D/build/all_$s $(cat $D/build/shard_$s.lst)
    gcc -O2 -DPROGS_H="\"$D/build/all_$s.h\"" -o $D/build/all_$s.bin $D/src/driver.c $D/build/all_$s.S
    DUMP=$D/build/all_dump_$s.txt DUMPK=2000 nice -n 10 $D/build/all_$s.bin $PT $NR $((1000 + s)) > $D/logs/all_$s.log 2> $D/logs/all_$s.err || true ) &
done
wait
cat $D/build/all_dump_*.txt > $D/build/all_dump.txt
python3 $D/src/x86isa_transcribe.py $D/build/all_dump.txt > $D/logs/x86isa_all.log 2>&1 || true
: > $D/logs/judge_all.log
for f in $FILES; do
  m=$(grep -o 'model=[a-z]*' "$f" | head -1 | cut -d= -f2); m=${m:-reg}
  is=$(grep -o 'iset=I[01]' "$f" | head -1 | cut -d= -f2); is=${is:-I1}
  r=$(cd $T && timeout 3000 python3 shared/judge.py "$f" --strict --model $m --iset $is -q 2>&1 | tail -1)
  echo "$f model=$m iset=$is :: $r" >> $D/logs/judge_all.log
done
echo ALLDONE >> $D/logs/judge_all.log
