#!/bin/bash
# Run every claim script (or those matching $1) one after the other, 1 core. Summary: build/SUMMARY.txt
ART=$(cd "$(dirname "$0")" && pwd)
pat=${1:-}
for s in $ART/claims/*${pat}*.sh; do
  r=$(nice -n 10 bash "$s" 2>&1 | grep "^RESULT")
  echo "$(date '+%F %T') ${r:-RESULT $(basename $s .sh): NO RESULT LINE}" | tee -a $ART/build/SUMMARY.txt
done
