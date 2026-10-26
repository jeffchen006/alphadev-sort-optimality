#!/bin/bash
# skip if already started (s$i.txt exists) or done (in summary)
f=$1; i=$2; o=$4
[ -e $o/s$i.txt ] && exit 0
grep -q "^$i " $o/summary.txt 2>/dev/null && exit 0
exec ./runpt.sh "$@"
