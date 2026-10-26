#!/bin/bash
# sort4 K=19 NOP-mode cube c (#cmp = c, #cmov >= 10): cube4.sh c [extra args]
c=$1; shift
cd "$(dirname "$0")"
tag=sort4_I1_snapw_nop_K19_cmp$c${TAGX}
nice -n 10 python3 cegis.py --n 4 --k 19 --iset I1 --out snapw --rules all --nop --min-cmp $c --max-cmp $c --min-cmov 10 \
  ${PERMS---perms} --json res/$tag.json --save found/sat2_$tag.s --dump cert/$tag.cnf "$@" > logs/$tag.log 2>&1
