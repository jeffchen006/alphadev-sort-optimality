#!/bin/bash
# x86 agent: run the real-CPU harness on every programs/found/*.s that is new or changed since the last check.
# Usage: check_found.sh [PER_TYPE NRAND]  -> logs/found_<stamp>.log ; list of checked files + md5 in logs/found_checked.txt
D=$(cd "$(dirname "$0")" && pwd); T=$(cd $D/../.. && pwd)
PT=${1:-5000} NR=${2:-3000000}
touch $D/logs/found_checked.txt
NEW=()
for f in $T/programs/found/*.s; do
  h=$(md5sum "$f" | cut -d' ' -f1)
  grep -q "$h $f" $D/logs/found_checked.txt || NEW+=("$f")
done
[ ${#NEW[@]} -eq 0 ] && { echo "no new found programs"; exit 0; }
S=$(date +%m%d_%H%M)
nice -n 10 $D/run_harness.sh found_$S $PT $NR "${NEW[@]}" > $D/logs/found_$S.log 2> $D/logs/found_$S.err
for f in "${NEW[@]}"; do echo "$(md5sum "$f" | cut -d' ' -f1) $f" >> $D/logs/found_checked.txt; done
awk '{print $NF, $2, $1}' $D/logs/found_$S.log
