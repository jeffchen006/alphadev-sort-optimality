#!/bin/bash
# d7: base pool + 1 select column (sels.pkl, 7957), K=31, R=9, 5 parallel; waits for run_e2 to end
cd $(dirname $0)
while pgrep -f "bash ./run_e2.sh" >/dev/null; do sleep 60; done
seq 0 7956 | xargs -P 5 -I{} sh -c 'python3 mkpool_sel.py pools/s{}.txt {} && nice -n 10 ./pool_bfs pools/s{}.txt 31 9 2>/dev/null | grep -E "FOUND|MIN|NONE|ABORT" | head -1 | sed "s/^/s{} /"; rm -f pools/s{}.txt' > bfs_s1.txt
