#!/bin/bash
# when fw14 is done, run w6 two-select neighbours with 12 workers until 06:00, then 6
cd /path/to/repo/agents/team/d5-extend/pt
while [ $(cat fw14n/summary.txt | wc -l) -lt 3881 ]; do sleep 60; done
mkdir -p w6n
TMO=3600 bash -c 'seq 1 3627 | xargs -P 6 -I{} ./runpt_chk.sh w6_n2.sk {} 31 w6n 0' &
TMO=3600 bash -c 'seq 3627 -1 1 | xargs -P 6 -I{} ./runpt_rev.sh w6_n2.sk {} 31 w6n 0' &
wait
