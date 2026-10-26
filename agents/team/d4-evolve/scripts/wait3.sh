#!/bin/bash
# wake on: any new "^prog" line in key satrep logs, any SATREP, evo best below current
cd "$(dirname "$0")/.."
K="logs/satrep_fresh31_q3.log logs/satrep_fresh31_q4.log logs/satrep_w6q4_22.log logs/satrep_w6q4_28.log logs/satrep_w6q4_11.log logs/satrep_fw14_q3_r4.log logs/satrep_fw14_q4.log logs/satrep_fw14_q3.log logs/satrep_b31a_q3.log logs/satrep_b31a_q4.log logs/satrep_net41_q4.log"
cnt() { echo $(( $(cat $K 2>/dev/null | grep -c "^prog") + $(cat logs/satrep_*.log | grep -c SATREP) + $(cat logs/satrep_w6_s*.log | grep -c "^prog" | awk '{print ($1>=32)}') )); }
best() { echo 99 | grep "best fw" | sed 's/.*best fw=\([0-9]*\).*/\1/' | sort -n | head -1; }
c0=$(cnt); b0=$(best)
while [ "$(cnt)" -eq "$c0" ]; do sleep 60; done
for f in $K; do grep "^prog" $f | sed "s|^|$f: |"; done; cat logs/satrep_*.log | grep SATREP; echo "w6 done: $(cat logs/satrep_w6_s*.log | grep -c '^prog')/32"; echo 99 | grep "best fw" | tail -2
