#!/bin/bash
cd "$(dirname "$0")/.."
while [ $(ps -eo args | grep -c "^python3 -u src/satrep.py runs/w6_del1.txt") -ge 6 ]; do sleep 60; done
TLIM=86400 nice -n 10 python3 -u src/satrep.py runs/b31a.txt 4 > logs/satrep_b31a_q4.log 2>&1
