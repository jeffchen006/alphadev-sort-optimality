#!/bin/bash
# queue: fr31 two-select neighbours, then w6 ones (6 base + 6 extra until 06:00)
cd /path/to/repo/agents/team/d5-extend/pt
while [ $(sort -u fw14n/summary.txt | wc -l) -lt 3881 ]; do sleep 60; done
for job in "fr31_n2.sk 4554 fr31n" "w6_n2.sk 3627 w6n"; do
  set -- $job; mkdir -p $3; touch $3/summary.txt
  TMO=3600 bash -c "seq 1 $2 | ./d5xargs -P 6 -I{} ./runpt_chk.sh $1 {} 31 $3 0" &
  TMO=3600 bash -c "seq $2 -1 1 | ./d5xargs -P 2 -I{} ./runpt_rev.sh $1 {} 31 $3 0" &
  wait
done
