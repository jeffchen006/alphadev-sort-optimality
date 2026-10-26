#!/bin/bash
# one-select neighbours of the c=8 seeds, seed by seed as generated, then d7 orders
while true; do
  for d in sk/c8n1/*/; do d=${d%/}; [ -f $d/.done ] && continue; ls $d/*.txt >/dev/null 2>&1 || { touch $d/.done; continue; }
    if [ -f $d/../../../logs/gen_c8n1.log ]; then :; fi
    ./batch3.sh $d 31 7 3600 >/dev/null; touch $d/.done; done
  grep -q "GEN DONE" logs/gen_c8n1.log && [ $(ls -d sk/c8n1/*/ | wc -l) -eq $(ls sk/c8n1/*/.done | wc -l) ] && break
  sleep 60
done
echo C8N1 DONE
./batch3.sh sk/ord9 31 7 3600
./batch3.sh sk/ord10 31 7 3600
