#!/bin/bash
# wait for the bound-18 result, stop the old loop before it starts bound 19 with the old binary, start bound 19 (v4)
cd "$(dirname "$0")"
until grep -q "KB=19" logs/n4_ng3.log; do sleep 5; done
pkill -x enum_out_v3; pkill -f run_n4.sh
nohup ./run_n4_19.sh > logs/n4_ng4_k19.log 2>&1 &
