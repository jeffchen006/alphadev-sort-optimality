#!/bin/bash
# d7: after the net9_41 sweep: stop run_q2 (before its e2 stage), run 4,609 ten-comparator network pools, then e2
cd $(dirname $0)
while [ ! -s bfs_n41.txt ] || [ $(wc -l < bfs_n41.txt) -lt 6739 ]; do sleep 30; done
kill 1868352; sleep 2; pgrep -f "[x]args -P 5 -L 1" | xargs -r kill; sleep 1; rm -f pools/p*_*.txt; rm -f bfs_e2.txt
ls pools/net10_*.txt | xargs -n1 basename | sed 's/.txt//' | xargs -P 5 -I{} sh -c 'nice -n 10 ./pool_bfs pools/{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/{} /"; echo' > bfs_net10.txt
python3 -c "
import itertools
for i,j in itertools.combinations(range(155),2): print(i,j)" | xargs -P 5 -L 1 sh -c 'python3 mkpool.py pools/p$0_$1.txt $0 $1 && nice -n 10 ./pool_bfs pools/p$0_$1.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/p$0_$1 /"; echo; rm -f pools/p$0_$1.txt' > bfs_e2.txt
