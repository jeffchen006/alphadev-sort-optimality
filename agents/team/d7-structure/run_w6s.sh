#!/bin/bash
# d7: c=8 k=32 (w6) pool + one select extra (indices 270..7665 of nbrw6.pkl), K=31, auto R, 3 parallel
cd $(dirname $0)
seq 270 7665 | xargs -P 3 -I{} sh -c 'python3 mkpool_nbr.py nbrw6.pkl pools/w6s_{}.txt {} && nice -n 10 ./pool_bfs pools/w6s_{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/w6s_{} /"; echo; rm -f pools/w6s_{}.txt' > bfs_w6s.txt
