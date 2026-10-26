#!/bin/bash
# stop enum runs if available memory on the shared machine drops below 40 GB
while pgrep -x enum_out_v9 >/dev/null || pgrep -x count >/dev/null; do
  a=$(awk '/MemAvailable/{print int($2/1048576)}' /proc/meminfo)
  if [ "$a" -lt 40 ]; then echo "$(date) MemAvailable=${a}G -> kill" >> logs/memguard.log; pkill -x enum_out_v9; pkill -x count; fi
  sleep 5
done
