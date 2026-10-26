#!/bin/bash
# d7: after the select sweep: stop run_all (before its e2 stage), run net9_41 neighbourhood (6,739 one-extra pools), then e2
cd $(dirname $0)
while [ $(wc -l < bfs_s1.txt) -lt 7957 ]; do sleep 30; done
kill 4035468; sleep 2; pgrep -f "[x]args -P 5 -L 1" | xargs -r kill; sleep 1; rm -f pools/p*_*.txt; mv bfs_e2.txt bfs_e2_partial.txt 2>/dev/null
seq 0 6738 | xargs -P 5 -I{} sh -c 'python3 mkpool_nbr.py nbr41.pkl pools/n41_{}.txt {} && nice -n 10 ./pool_bfs pools/n41_{}.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/n41_{} /"; echo; rm -f pools/n41_{}.txt' > bfs_n41.txt
python3 -c "
import itertools
for i,j in itertools.combinations(range(155),2): print(i,j)" | xargs -P 5 -L 1 sh -c 'python3 mkpool.py pools/p$0_$1.txt $0 $1 && nice -n 10 ./pool_bfs pools/p$0_$1.txt 31 0 2>/dev/null | grep -E "^R =|MIN|NONE|ABORT" | tr "\n" " " | sed "s/^/p$0_$1 /"; echo; rm -f pools/p$0_$1.txt' > bfs_e2.txt
