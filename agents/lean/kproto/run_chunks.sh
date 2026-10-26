#!/bin/bash
# usage: run_chunks.sh DIR (e.g. KProto/Cn3k8I1); compiles Chunk*.lean and Nodes.lean, 4 in parallel
D=$1
export PATH=$HOME/.elan/bin:$PATH
mkdir -p .lake/build/lib/lean/$D logs
ls $D/Chunk*.lean $D/Nodes.lean | xargs -P 4 -I{} bash -c 'f={}; b=$(basename $f .lean); o=.lake/build/lib/lean/'$D'/$b.olean; [ -f $o ] && exit 0; /usr/bin/time -f "$b %e s user %U sys %S mem %M KB" lake env lean -j 1 --tstack=1000000 $f -o $o > logs/k9_$b.out 2>&1 || echo "FAIL $b"; tail -1 logs/k9_$b.out'
