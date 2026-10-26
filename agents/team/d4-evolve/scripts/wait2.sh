#!/bin/bash
# wait until all 6 w6 shards end or any SAT hit appears in satrep logs; print summary
cd "$(dirname "$0")/.."
while true; do
  hit=$(cat logs/satrep_*.log | grep -c "SATREP")
  run=$(ps -eo args | grep -c "^python3 -u src/satrep.py runs/w6_del1.txt")
  [ "$hit" -gt 0 ] || [ "$run" -eq 0 ] && break
  sleep 120
done
echo "hits=$hit running_w6=$run"; cat logs/satrep_w6_s*.log | grep "^prog" | awk '{print $4}' | sort | uniq -c
grep -l SATREP logs/satrep_*.log
