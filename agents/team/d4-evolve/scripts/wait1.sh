#!/bin/bash
# wait until a new result line appears in the watched logs; print it
cd "$(dirname "$0")/.."
F="logs/satrep_b29_q3.log logs/satrep_b29_q4.log logs/satrep_net41_q4.log logs/satrep_net41_q4r.log logs/mergec_14.log logs/mergec_15.log logs/mergec_16.log logs/mergec_17.log"
G="logs/satrep_pos33.log logs/satrep_q3_s*.log logs/satrep_net41.log"
n0=$(( $(cat $F 2>/dev/null | grep -c -E "^prog|RESULT|SATREP") + $(cat $G 2>/dev/null | grep -c -E "SATREP| SAT ") ))
while true; do
  n=$(( $(cat $F 2>/dev/null | grep -c -E "^prog|RESULT|SATREP") + $(cat $G 2>/dev/null | grep -c -E "SATREP| SAT ") ))
  [ "$n" -gt "$n0" ] && break
  sleep 60
done
for f in $F; do grep -E "^prog|RESULT|SATREP" $f | sed "s|^|$f: |"; done
