#!/bin/bash
# poll d2 results; re-check every UNSAT case record not yet in checked.log with up to 6 parallel workers
R=/path/to/repo/agents/team/d2-lattice/c2/results
D=/path/to/repo/agents/team/judge/dira
touch $D/checked.log
while true; do
  for f in $R/*.json; do
    [ -f "$f" ] || continue
    b=$(basename $f .json)
    grep -q "^$b " $D/checked.log && continue
    grep -q '"status": "UNSAT"' $f || continue
    echo $f
  done | xargs -r -P6 -n1 sh -c 'python3 '$D'/checkcase.py "$0" >> '$D'/checked.log 2>&1'
  sleep 600
done
