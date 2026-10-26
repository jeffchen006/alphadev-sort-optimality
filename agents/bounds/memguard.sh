#!/bin/bash
# stop my long search if it grows past 40 GB RSS or the machine has < 40 GB available
while pgrep -x rsearch_x >/dev/null; do
  rss=$(ps -o rss= -C rsearch_x | sort -n | tail -1); avail=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
  if [ "${rss:-0}" -gt 41943040 ] || [ "$avail" -lt 41943040 ]; then pkill -x rsearch_x; echo "$(date) memguard stop rss=$rss avail=$avail" >> logs/R3x_n4.log; fi
  sleep 60
done
