#!/bin/bash
# restart the resumable k<=19 export after an outside kill (OOM); stop when the .gz checksum is printed
cd "$(dirname "$0")"
for i in $(seq 1 30); do
  while pgrep -f run_cert19.sh >/dev/null; do sleep 60; done
  grep -q "sort4_I1_k19_ng1.cert.gz$" logs/cert19.log && exit 0
  echo "=== supervise19: restart $i at $(date)" >> logs/cert19.log
  setsid nohup ./run_cert19.sh >> logs/cert19.log 2>&1 < /dev/null &
  sleep 30
done
