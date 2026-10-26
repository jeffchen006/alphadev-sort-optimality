#!/bin/bash
until grep -q "C8N1 DONE" logs/chain8.log; do sleep 60; done
ps -eo pid,args | awk '$2=="/bin/bash" && $3=="./chain8.sh"{print $1}' | xargs -r kill
ps -eo pid,args | awk '$3=="./batch3.sh" && $4 ~ /ord/{print $1}' | xargs -r kill
ps -eo pid,args | awk '$2=="./dagx_bin3" && $3 ~ /ord/{print $1}' | xargs -r kill
sleep 3
for f in sk/ord9/res/*.out; do grep -q "^RESULT NONE\|^RESULT FOUND" $f || : > $f; done 2>/dev/null
./batch3.sh sk/r4 31 7 3600
./batch3.sh sk/ord9 31 7 3600
./batch3.sh sk/ord10 31 7 3600
