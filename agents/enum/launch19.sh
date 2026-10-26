#!/bin/bash
cd "$(dirname "$0")"
setsid nohup ./run_n4_19.sh > logs/n4_v8_k19.log 2>&1 < /dev/null &
sleep 3
setsid nohup ./memguard.sh > /dev/null 2>&1 < /dev/null &
