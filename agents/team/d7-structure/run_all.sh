#!/bin/bash
# d7: all pool sweeps with auto-R (R = 5 + K - min creations - min cmp blocks; judge fix). 5 parallel, nice 10.
cd $(dirname $0)
one() { # name poolcmd K
  sh -c "$2" && nice -n 10 ./pool_bfs pools/$1.txt $3 0 2>/dev/null | grep -E "^R =|FOUND|MIN|NONE|ABORT" | grep -v FOUND | tr '\n' ' ' | sed "s/^/$1 /"; echo; rm -f pools/$1.txt
}
export -f one
# 1) net9 K=31 and K=32 (pool files kept)
ls pools/net9_*.txt | xargs -n1 basename | sed 's/.txt//' | xargs -P 5 -I{} sh -c 'nice -n 10 ./pool_bfs pools/{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/{} /"; echo' > bfs_net9.txt
# 2) base + 1 extra
seq 0 154 | xargs -P 5 -I{} sh -c 'python3 mkpool.py pools/e{}.txt {} && nice -n 10 ./pool_bfs pools/e{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/e{} /"; echo; rm -f pools/e{}.txt' > bfs_e1.txt
# 3) net9 K=32
ls pools/net9_*.txt | xargs -n1 basename | sed 's/.txt//' | xargs -P 5 -I{} sh -c 'nice -n 10 ./pool_bfs pools/{}.txt 32 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/{} /"; echo' > bfs_net9_32.txt
# 4) base + 1 select
seq 0 7956 | xargs -P 5 -I{} sh -c 'python3 mkpool_sel.py pools/s{}.txt {} && nice -n 10 ./pool_bfs pools/s{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/s{} /"; echo; rm -f pools/s{}.txt' > bfs_s1.txt
# 5) base + 2 extras
python3 -c "
import itertools
for i,j in itertools.combinations(range(155),2): print(i,j)" | xargs -P 5 -L 1 sh -c 'python3 mkpool.py pools/p$0_$1.txt $0 $1 && nice -n 10 ./pool_bfs pools/p$0_$1.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/p$0_$1 /"; echo; rm -f pools/p$0_$1.txt' > bfs_e2.txt
