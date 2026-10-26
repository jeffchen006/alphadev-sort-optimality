#!/bin/bash
# usage: run3.sh DIR TAG P CPUS NODE : kernel-check all Mod*/NMod* of DIR, P in parallel, pinned to CPUS, memory on NUMA NODE.
# Resumable: modules with an .olean are skipped. Then builds Final.lean.
D=$1; TAG=$2; P=${3:-4}; CPUS=${4:-0-3}; NODE=${5:-0}
export PATH=$HOME/.elan/bin:$PATH
O=.lake/build/lib/lean/$D; mkdir -p $O logs/$TAG
export O D TAG CPUS NODE
ls $D | grep -E '^N?Mod[0-9]+\.lean$' | sed 's/\.lean$//' | xargs -P $P -I{} bash -c '[ -f $O/{}.olean ] && exit 0; /usr/bin/time -f "{} %e s user %U sys %S mem %M KB" nice -n 10 taskset -c $CPUS python3 -I tools/membind.py $NODE lake env lean -j 1 --tstack=1000000 $D/{}.lean -o $O/{}.olean > logs/$TAG/{}.out 2>&1 || echo "FAIL {}"; tail -1 logs/$TAG/{}.out' >> logs/$TAG/progress.txt
nice -n 10 taskset -c $CPUS python3 -I tools/membind.py $NODE lake env lean -j 1 --tstack=1000000 $D/Final.lean -o $O/Final.olean > logs/$TAG/Final.out 2>&1 && echo "FINAL OK" >> logs/$TAG/progress.txt || echo "FINAL FAIL" >> logs/$TAG/progress.txt
