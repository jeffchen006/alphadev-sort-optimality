#!/bin/bash
# [A15] positive control: from the set-model state after t instructions of a pure-lattice k=32 program, budget 32-t, +1, +2
for f in lat32_0.s lat32_1.s lat32_2.s; do for t in 24 20 16 12 8; do
  for x in 0 1 2; do b=$((32-t+x))
    LAT=2 CMAX=16 PREFIX=$f:$t nice -n 10 ./lat_d2 5 0 1 $b 10 1 > logs/ctl_${f%.s}_t$t.log 2>&1
    grep -q 'RESULT min' logs/ctl_${f%.s}_t$t.log && break
  done
  echo "$f t=$t budget=$b $(grep -E '^PREFIX' logs/ctl_${f%.s}_t$t.log | sed 's/PREFIX [^:]*: //') $(grep RESULT logs/ctl_${f%.s}_t$t.log)"
done; done
