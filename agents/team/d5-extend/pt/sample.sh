#!/bin/bash
# sampled check: 30 random completions per prefix (seed 1), full dagx_bin2 K=31 (no node limit, 30 min timeout)
cd /path/to/repo/agents/team/d5-extend/pt
while [ $(wc -l < pre/counts.txt) -lt 61 ]; do sleep 60; done
rm -f samp.sk; for f in pre/p*.sk; do shuf -n 30 --random-source=<(yes 1) $f >> samp.sk; done
n=$(wc -l < samp.sk)
TMO=1800 sh -c "seq 1 $n | xargs -P 4 -I{} ./runpt.sh samp.sk {} 31 samp31 0"
