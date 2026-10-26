#!/bin/bash
# d7 [A8 attack]: c=8 term-set classes 2 and 3: own pool + 1 extra (lattice min/max of pool pairs, or a select by one of
# the program's flags), K=31, auto R, pool_bfs v2. 3 parallel.
cd $(dirname $0)
for c in 2 3; do
  N=$(python3 -c "import pickle;print(len(pickle.load(open('nbrc8_$c.pkl','rb'))[1]))")
  seq 0 $((N-1)) | xargs -P 3 -I{} sh -c "python3 mkpool_nbr.py nbrc8_$c.pkl pools/c8_${c}_{}.txt {} && nice -n 10 ./pool_bfs pools/c8_${c}_{}.txt 31 0 2>/dev/null | grep -E '^R =|MIN|NONE|ABORT' | tr '\n' ' ' | sed 's/^/c8_${c}_{} /'; echo; rm -f pools/c8_${c}_{}.txt" > bfs_c8_$c.txt
done
