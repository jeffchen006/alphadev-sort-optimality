#!/bin/bash
# d7: 10-comparator pools (K=32, MIN k) first, then net9_41 neighbourhood, then missing one-select pools (auto R)
cd $(dirname $0)
ls pools/net10_*.txt | xargs -n1 basename | sed 's/.txt//' | xargs -P 5 -I{} sh -c 'nice -n 10 ./pool_bfs pools/{}.txt 32 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/{} /"; echo' > bfs_net10_32.txt
seq 0 6738 | xargs -P 5 -I{} sh -c 'python3 mkpool_nbr.py nbr41.pkl pools/n41_{}.txt {} && nice -n 10 ./pool_bfs pools/n41_{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/n41_{} /"; echo; rm -f pools/n41_{}.txt' > bfs_n41.txt
awk '{print $1}' bfs_s1.txt | grep . | sed 's/s//' | sort -n > s1_done.txt
seq 0 7956 | sort | comm -23 - <(sort s1_done.txt) | sort -n | xargs -P 5 -I{} sh -c 'python3 mkpool_sel.py pools/s{}.txt {} && nice -n 10 ./pool_bfs pools/s{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/s{} /"; echo; rm -f pools/s{}.txt' >> bfs_s1.txt
