#!/bin/bash
# check_unsat.sh — certified UNSAT check of one DIMACS CNF.
#   solver (cadical | kissat) -> proof -> LRAT -> cake_lpr (CakeML, formally verified).
# Usage: check_unsat.sh [-s cadical|kissat] [-t SECONDS] [-k] [-x] [-T] CNF
#   -s  solver / proof path (default cadical):
#         cadical : cadical --lrat writes LRAT directly; drat-trim not used
#         kissat  : kissat writes DRAT; drat-trim -L converts DRAT -> LRAT
#   -t  solver time limit in seconds (default 36000)
#   -k  keep proof files (default: delete after a successful check, keep hashes)
#   -x  also run lrat-check (unverified C checker) as a second opinion (needs -T: text LRAT)
#   -T  text proofs (default: binary DRAT/LRAT, 2-3x smaller; cake_lpr reads binary LRAT)
# Output: log in agents/proofs/logs/, one line appended to agents/proofs/checked.tsv.
# Exit 0 = "s VERIFIED UNSAT" from cake_lpr; 10 = solver says SAT; 1 = any failure.
# Trust base: cake_lpr binary (HOL4/CakeML proof of the checker), the CNF file itself,
# gcc + basis_ffi.c (C wrapper), the OS. Solver, drat-trim and this script are NOT trusted.
{ # whole body in one block: bash parses it before running, so editing this file cannot break running checks
set -uo pipefail

P=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$P/../.." && pwd)
CAKE=$P/tools/bin/cake_lpr
DRATTRIM=$P/tools/bin/drat-trim
LRATCHECK=$P/tools/bin/lrat-check
CADICAL=$ROOT/bin/cadical
KISSAT=$ROOT/bin/kissat
HEAP_MB=${CAKE_HEAP_MB:-32768}
STACK_MB=${CAKE_STACK_MB:-8192}

SOLVER=cadical; TLIM=36000; KEEP=0; XCHECK=0; BIN=true
while getopts "s:t:kxT" o; do
  case $o in
    s) SOLVER=$OPTARG ;; t) TLIM=$OPTARG ;; k) KEEP=1 ;; x) XCHECK=1 ;; T) BIN=false ;;
    *) sed -n '2,15p' "$0"; exit 1 ;;
  esac
done
shift $((OPTIND-1))
[ $# -eq 1 ] || { sed -n '2,15p' "$0"; exit 1; }
CNF=$(readlink -f "$1")
[ -f "$CNF" ] || { echo "no such file: $1"; exit 1; }

mkdir -p "$P/logs" "$P/proofs"
STAMP=$(date +%Y%m%d-%H%M%S)
BASE=$(basename "$CNF" .cnf)_${SOLVER}_$STAMP
LOG=$P/logs/$BASE.log
LRAT=$P/proofs/$BASE.lrat
DRAT=$P/proofs/$BASE.drat

log() { echo "$*" | tee -a "$LOG"; }
sha() { sha256sum "$1" | cut -d' ' -f1; }
now() { date +%s.%N; }

log "c check_unsat.sh  date=$(date -Is) host=$(hostname)"
log "c cnf=$CNF"
log "c cnf_sha256=$(sha "$CNF")"
log "c cnf_header=$(grep -m1 '^p ' "$CNF")"
log "c solver=$SOLVER tlim=$TLIM binary_proof=$BIN"
log "c cake_lpr_sha256=$(sha "$CAKE")"

T0=$(now)
if [ "$SOLVER" = cadical ]; then
  log "c solver_bin=$CADICAL version=$($CADICAL --version)"
  timeout "$TLIM" "$CADICAL" -q --lrat=true --binary=$BIN "$CNF" "$LRAT" >> "$LOG" 2>&1
  RC=$?
elif [ "$SOLVER" = kissat ]; then
  log "c solver_bin=$KISSAT version=$($KISSAT --version)"
  timeout "$TLIM" "$KISSAT" -q $([ $BIN = true ] || echo --no-binary) "$CNF" "$DRAT" >> "$LOG" 2>&1
  RC=$?
else
  log "c unknown solver $SOLVER"; exit 1
fi
T1=$(now)
log "c solver_exit=$RC solver_time=$(echo "$T1 - $T0" | bc)"

finish() {  # status
  local st=$1
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$(date -Is)" "$CNF" "$(sha "$CNF")" "$SOLVER" \
    "${PROOF_SHA:--}" "$st" "$LOG" >> "$P/checked.tsv"
  log "c RESULT $st"
}

if [ $RC -eq 10 ]; then finish SAT; exit 10; fi
if [ $RC -ne 20 ]; then finish "SOLVER_FAIL($RC)"; exit 1; fi

if [ "$SOLVER" = kissat ]; then
  log "c drat_sha256=$(sha "$DRAT") drat_bytes=$(stat -c %s "$DRAT")"
  T2=$(now)
  "$DRATTRIM" "$CNF" "$DRAT" -L "$LRAT" -w -t "$TLIM" > "$P/logs/$BASE.drattrim" 2>&1
  log "c drat-trim: $(tr "\r" "\n" < "$P/logs/$BASE.drattrim" | grep -a -E "^s " | head -1) time=$(echo "$(now) - $T2" | bc)"
  tr "\r" "\n" < "$P/logs/$BASE.drattrim" | grep -a -q "^s VERIFIED" || { finish DRATTRIM_FAIL; exit 1; }
  [ $KEEP -eq 1 ] || rm -f "$DRAT"
fi

PROOF_SHA=$(sha "$LRAT")
log "c lrat=$LRAT lrat_sha256=$PROOF_SHA lrat_bytes=$(stat -c %s "$LRAT")"

T3=$(now)
OUT=$("$CAKE" --CML_HEAP_SIZE=$HEAP_MB --CML_STACK_SIZE=$STACK_MB "$CNF" "$LRAT" 2>&1)
CRC=$?
log "c cake_lpr_exit=$CRC cake_lpr_time=$(echo "$(now) - $T3" | bc)"
log "$OUT"

if [ $XCHECK -eq 1 ]; then
  log "c lrat-check: $("$LRATCHECK" "$CNF" "$LRAT" 2>&1 | grep -E '^s|^c VERIFIED|FAIL' | head -2)"
fi

if [ "$OUT" = "s VERIFIED UNSAT" ]; then
  finish VERIFIED_UNSAT
  [ $KEEP -eq 1 ] || rm -f "$LRAT"
  exit 0
fi
finish CAKE_LPR_FAIL
exit 1
exit 1
}
