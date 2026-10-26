#!/bin/bash
# D2: exact search over ALL pure-lattice, no-T M_out sort5 programs, k <= 31 (lat_out = enum_out + LAT filter).
# "RESULT none<=31" => no pure-lattice sort5 shorter than AlphaDev (search result). "goal state found" => recover + judge.
# Disk-based layered BFS (EXTDIR), low RSS. Start only after the coordinator's go (sort4 check passed).
cd "$(dirname "$0")/tools"; mkdir -p /path/to/repo/agents/sort5-lab/ext31
LAT=2 NOREC=1 CMAX=16 EXTDIR=/path/to/repo/agents/sort5-lab/ext31 \
  /usr/bin/time -f "%es %MKB" nice -n 5 ./lat_out 5 0 1 31 ${THREADS:-16} 1 > ../logs/d2_k31.log 2>&1
