#!/bin/bash
# d7: after run_all (e2) ends: rest of one-select sweep, net9_41 neighbourhood, 10-comparator nets (auto R, 5 parallel)
cd $(dirname $0)
while ps -p 4035468 >/dev/null; do sleep 30; done
seq 3205 7956 | xargs -P 5 -I{} sh -c 'python3 mkpool_sel.py pools/s{}.txt {} && nice -n 10 ./pool_bfs pools/s{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/s{} /"; echo; rm -f pools/s{}.txt' >> bfs_s1.txt
seq 0 6738 | xargs -P 5 -I{} sh -c 'python3 mkpool_nbr.py nbr41.pkl pools/n41_{}.txt {} && nice -n 10 ./pool_bfs pools/n41_{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/n41_{} /"; echo; rm -f pools/n41_{}.txt' > bfs_n41.txt
ls pools/net10_*.txt | xargs -n1 basename | sed 's/.txt//' | xargs -P 5 -I{} sh -c 'nice -n 10 ./pool_bfs pools/{}.txt 32 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/{} /"; echo' > bfs_net10_32.txt
