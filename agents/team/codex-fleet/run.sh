#!/usr/bin/env bash
# Run one Codex worker: run.sh w1   (log in wN/run.log, last message in wN/last.md)
cd "$(dirname "$0")" || exit 1
w=$1; q=$(bash /path/to/workspace/schur6/lib/codex_quota.sh | sed -n 's/used=\([0-9.]*\)%.*/\1/p')
# the newest Codex log may not hold a rate_limits record yet (another worker just started): use the last good value
if [ -n "$q" ]; then echo "$q" > .quota_last; else q=$(cat .quota_last 2>/dev/null); fi
awk -v q="${q:-100}" 'BEGIN{exit !(q < 85)}' || { echo "codex quota ${q}% >= 85%: not started" >> $w/run.log; exit 1; }
declare -A M=([w1]=68 [w2]=76 [w3]=76 [w4]=69 [w5]=70 [w6]=71 [w7]=72 [w8]=73 [w9]=76 [w10]=80-83 [w11]=84-87 [w12]=88-91 [w13]=74 [w14]=75); CORES=${M[$w]}
taskset -c $CORES nice -n 10 codex exec --skip-git-repo-check -s workspace-write -C "$PWD/$w" -c model_reasoning_effort="high" \
  -o "$PWD/$w/last.md" - < "$w/BRIEF.md" >> "$w/run.log" 2>&1
echo "[$(date '+%F %T')] worker $w exit $?" >> "$w/run.log"
grep -h '^FOUND' "$w/RESULTS.md" 2>/dev/null | head -3 | while read -r l; do /path/to/repo/bin/notify coordinator "codex-fleet $w: $l"; done
