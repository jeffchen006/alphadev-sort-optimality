#!/bin/bash
# second base runner (6 cores, uses PT1's freed cores): fr31 then w6, middle-out order, lock via runpt_chk
cd /path/to/repo/agents/team/d5-extend/pt
while [ ! -d fr31n ]; do sleep 30; done
( seq 2277 4554; seq 1 2276 ) | ./d5xargs -P 6 -I{} ./runpt_chk.sh fr31_n2.sk {} 31 fr31n 0
while [ ! -d w6n ]; do sleep 30; done
( seq 1814 3627; seq 1 1813 ) | ./d5xargs -P 6 -I{} ./runpt_chk.sh w6_n2.sk {} 31 w6n 0
