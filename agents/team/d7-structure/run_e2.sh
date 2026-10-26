#!/bin/bash
# d7: base pool + 2 extra lattice terms (all 155C2 pairs), K=31, R=9, 5 parallel
cd $(dirname $0)
python3 -c "
import itertools
for i,j in itertools.combinations(range(155),2): print(i,j)" | xargs -P 5 -L 1 sh -c 'python3 mkpool.py pools/p$0_$1.txt $0 $1 && nice -n 10 ./pool_bfs pools/p$0_$1.txt 31 9 2>/dev/null | grep -E "FOUND|MIN|NONE" | head -1 | sed "s/^/p$0_$1 /"; rm -f pools/p$0_$1.txt' > bfs_e2.txt
