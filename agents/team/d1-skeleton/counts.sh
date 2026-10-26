#!/bin/bash
# per-set counts: total, NONE, FOUND, TIMEOUT(=UNKNOWN), pending
for d in sk/fresh31n sk/w3x_n c8n1 sk/r4 sk/fam_sel sk/r3p8 sk/d4c8 sk/d4c9 sk/ord9 sk/ord10 sk/d4c7; do
  if [ $d = c8n1 ]; then F="sk/c8n1/*/*.txt"; R="sk/c8n1/*/res/*.out"; else F="$d/*.txt"; R="$d/res/*.out"; fi
  t=$(ls $F 2>/dev/null | wc -l); r=$(cat $R 2>/dev/null | grep -h "^RESULT" | awk '{print $2}' | sort | uniq -c | tr '\n' ' ')
  echo "$d total=$t $r"; done
