#!/bin/bash
# D2: exact search over ALL pure-lattice (LAT=2), no-T M_out sort5 programs, k <= 31, strict perms, I1, S5 symmetry.
# lat_d2 = sort5-lab lat_out + cached canonical/lattice check (same states: checked k<=26, k<=27).
cd "$(dirname "$0")"; D=$PWD/ext31; mkdir -p $D
LAT=2 NOREC=1 CMAX=16 PACK3=1 CHUNK=300000 EXTDIR=$D /usr/bin/time -f "%es %MKB" nice -n 10 ./lat_d2 5 0 1 31 12 1 >> logs/k31_ext.log 2>&1
