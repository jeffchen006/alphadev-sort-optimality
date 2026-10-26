# artifact/lib.sh — sourced by every claim script. Owner: spec.
set -uo pipefail
ART=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd "$ART/.." && pwd)
SRC=$ART/src            # frozen source snapshots (see snapshot.sh, src/SHA256SUMS)
BIN=$ROOT/bin           # prebuilt solvers: cadical, kissat, drat-trim, lrat-check (trust: NOT trusted, only cake_lpr/Lean/Rocq are)
CAKE=$ROOT/agents/proofs/tools/bin   # cake_lpr, cake_pb_cnf (CakeML-verified checkers)
export PATH=$HOME/.elan/bin:$PATH
NAME=$(basename "$0" .sh)
OUT=$ART/build/$NAME
mkdir -p "$OUT"
LOG=$OUT/run.log
: > "$LOG"
T0=$(date +%s)
say() { echo "$*" | tee -a "$LOG"; }
run() { say "+ $*"; "$@" >> "$LOG" 2>&1; local rc=$?; say "  (exit $rc)"; return $rc; }
expect() {  # expect "regex" : PASS if the log has it
  if grep -Eq -- "$1" "$LOG"; then say "EXPECT OK  : $1"; else say "EXPECT FAIL: $1"; FAILS=$((FAILS+1)); fi
}
FAILS=0
finish() {
  local dt=$(( $(date +%s) - T0 ))
  if [ $FAILS -eq 0 ]; then say "RESULT $NAME: PASS (${dt}s)"; exit 0; else say "RESULT $NAME: FAIL ($FAILS) (${dt}s)"; exit 1; fi
}
# certified UNSAT: cadical (untrusted) writes binary LRAT, cake_lpr (CakeML-verified) checks it. Usage: certify CNF
certify() {
  local cnf=$1 b=$OUT/$(basename "$1" .cnf)
  say "cnf $(basename $cnf) sha256 $(sha256sum "$cnf" | cut -d' ' -f1)"
  local t0=$(date +%s)
  nice -n 10 $BIN/cadical -q --lrat=true --binary=true "$cnf" "$b.lrat" > "$b.cadical.out"; local rc=$?
  say "cadical exit $rc ($(( $(date +%s) - t0 ))s) $(grep '^s ' $b.cadical.out)"
  [ $rc -eq 20 ] || { FAILS=$((FAILS+1)); return 1; }
  t0=$(date +%s)
  $CAKE/cake_lpr "$cnf" "$b.lrat" > "$b.cake.out" 2>&1
  say "cake_lpr ($(( $(date +%s) - t0 ))s): $(head -1 $b.cake.out)  [lrat $(du -h $b.lrat | cut -f1)]"
  [ -n "${KEEP:-}" ] || rm -f "$b.lrat"
}
# Pin multi-threaded tools (lake, native_decide Tasks) to ONE core: spec's quota is 1 core. Override: CORES=0-3
CORES=${CORES:-$(( $(nproc --all) - 1 ))}
TS="taskset -c $CORES"
# Mirror the repo layout under $OUT (Lean files read ../../../programs relative to their source dir)
mirror() { mkdir -p $OUT/agents; ln -sfn $BIN $OUT/bin; rm -rf $OUT/agents/$1; cp -r $SRC/$1 $OUT/agents/$1; rm -rf $OUT/programs; cp -r $SRC/programs $OUT/programs; }
