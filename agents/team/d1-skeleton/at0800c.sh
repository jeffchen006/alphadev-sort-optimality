#!/bin/bash
until [ $(date +%H%M) -ge 0800 ] && [ $(date +%H%M) -lt 1200 ]; do sleep 60; done
ps -eo pid,args | awk '$2=="/bin/bash" && ($3=="./queue4.sh" || $3=="./queue5.sh"){print $1}' | xargs -r kill
ps -eo pid,args | awk '$2=="xargs" && $3=="-a" && $4=="logs/queue_todo.txt"{print $1}' | xargs -r kill
# let running workers drain to <= 15 before the new queue (it skips running items)
while [ $(ps -eo args | awk '$1=="./dagx_bin3"' | wc -l) -gt 8 ]; do sleep 30; done
nohup ./queue5.sh 15 > logs/queue5.log 2>&1 &
echo switched $(date)
