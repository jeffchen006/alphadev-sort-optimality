#!/bin/bash
# usage: run2.sh DIR TAG   (DIR = KProto/D3k9I1): Data, then Mod*/NMod* (4 parallel), then Final. Logs in logs/TAG_*.out
D=$1; TAG=$2
export PATH=$HOME/.elan/bin:$PATH
O=.lake/build/lib/lean/$D; mkdir -p $O logs
L() { /usr/bin/time -f "$(basename $1 .lean) %e s user %U sys %S mem %M KB" lake env lean -j 1 --tstack=1000000 $1 -o $O/$(basename $1 .lean).olean; }
export -f L; export O
[ -f $O/Data.olean ] || L $D/Data.lean > logs/${TAG}_Data.out 2>&1 || { echo "FAIL Data"; exit 1; }
tail -1 logs/${TAG}_Data.out
ls $D/Mod*.lean $D/NMod*.lean | xargs -P 4 -I{} bash -c 'f={}; b=$(basename $f .lean); [ -f $O/$b.olean ] && exit 0; L $f > logs/'$TAG'_$b.out 2>&1 || echo "FAIL $b"; tail -1 logs/'$TAG'_$b.out'
L $D/Final.lean > logs/${TAG}_Final.out 2>&1 && echo "FINAL OK" || echo "FAIL Final"
tail -1 logs/${TAG}_Final.out
