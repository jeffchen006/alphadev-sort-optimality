#!/usr/bin/env bash
# fleet 20 cores: w10 80-83, w11 84-87, w12 88-91; w1 68,w4 69,w5 70,w6 71,w7 72,w8 73,w13 74,w14 75. loop 20 s
declare -A M=([w1]=68 [w2]=76 [w3]=76 [w4]=69 [w5]=70 [w6]=71 [w7]=72 [w8]=73 [w9]=76 [w10]=80-83 [w11]=84-87 [w12]=88-91 [w13]=74 [w14]=75)
while true; do
 for p in $(pgrep -u $USER); do
  c=$(readlink /proc/$p/cwd 2>/dev/null); n=""
  case $c in */codex-fleet/w[0-9]|*/codex-fleet/w[0-9]/*|*/codex-fleet/w1[0-4]|*/codex-fleet/w1[0-4]/*) n=${c#*codex-fleet/}; n=${n%%/*};; esac
  if [ -z "$n" ]; then a=$(tr '\0' ' ' </proc/$p/cmdline 2>/dev/null); case $a in *"codex exec"*"-C "*/codex-fleet/w*) n=${a#*codex-fleet/}; n=${n%% *}; n=${n%%/*};; esac; fi
  [ -n "$n" ] && [ -n "${M[$n]}" ] && taskset -acp ${M[$n]} $p >/dev/null 2>&1
 done; sleep 20; done
