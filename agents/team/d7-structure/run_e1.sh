#!/bin/bash
# d7: base pool + 1 extra lattice term, K=31, R=9, 6 parallel
cd $(dirname $0)
seq 0 154 | xargs -P 6 -I{} sh -c 'python3 mkpool.py pools/e{}.txt {} && nice -n 10 ./pool_bfs pools/e{}.txt 31 9 2>/dev/null | grep -E "FOUND|MIN|NONE" | head -1 | sed "s/^/e{} /"; rm -f pools/e{}.txt' > bfs_e1.txt
