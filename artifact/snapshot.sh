#!/bin/bash
# Freeze the source files that the claim scripts use (code + small data only; no logs, no build products).
# Re-run only when an owner asks for a new snapshot; then post the new src/SHA256SUMS hash on board/claims.md.
set -euo pipefail
ART=$(cd "$(dirname "$0")" && pwd); ROOT=$(cd "$ART/.." && pwd); S=$ART/src
[ -d "$S" ] && chmod -R u+w "$S"; rm -rf "$S"; mkdir -p "$S"
cp_tree() { # cp_tree <dest-name> <source-dir> <rsync filter args...>
  local d=$1 s=$2; shift 2
  mkdir -p "$S/$d"; rsync -a --prune-empty-dirs "$@" "$s/" "$S/$d/"
}
cp_tree shared   $ROOT/shared   --include='judge.py' --include='MODEL.md' --exclude='*'
cp_tree programs $ROOT/programs --include='*/' --include='*.s' --include='ORIGINAL_*' --exclude='*'
cp_tree spec     $ROOT/agents/spec/tools --include='*.py' --exclude='*'
cp $ROOT/agents/spec/x86/xdiff.py $S/spec/
cp_tree enum     $ROOT/agents/enum   --include='src/***' --include='PRUNING.md' --exclude='*'
cp_tree critic   $ROOT/agents/critic --include='*.cpp' --include='*.py' --include='BF_NOTES.md' --exclude='*'
cp_tree bounds   $ROOT/agents/bounds --include='*.cpp' --include='*.py' --include='*.md' --include='*.s' --exclude='*'
cp_tree theory   $ROOT/agents/theory --include='*.py' --include='lemmas.md' --exclude='*'
cp_tree sat      $ROOT/agents/sat    --include='*.py' --include='*.sh' --include='RULES.md' --exclude='*'
cp_tree sat2     $ROOT/agents/sat2   --include='*.py' --include='*.sh' --include='RULES.md' --include='cert/***' --include='res/' --include='res/sort3_I1_snapw_cnf_rall_c1_k*.json' --include='old/' --include='old/cnf_enc_round1.py' --include='old/cegis_round1.py' --exclude='*'
cp_tree proofs   $ROOT/agents/proofs --include='*.sh' --include='*.py' --include='*.md' --include='symcert/' --include='symcert/*.py' --include='enccheck/***' --exclude='*'
cp_tree lean     $ROOT/agents/lean   --exclude='.lake/' --exclude='scratch/' --exclude='proto/' --exclude='*.log'
cp_tree lean-reflect $ROOT/agents/lean-reflect --exclude='.lake/' --exclude='scratch/' --exclude='proto/' --exclude='logs/'
cp_tree lean-lrat $ROOT/agents/lean-lrat --exclude='.lake/' --exclude='scratch/' --exclude='cnf/' --exclude='logs/' --exclude='cmp/' --include='types/perm3.txt' --exclude='types/*' --exclude='*.lrat' --exclude='*.cnf'
cp_tree coq      $ROOT/agents/coq    --include='src/' --include='src/*.v' --include='extract/' --include='extract/v4/' --include='extract/v4/*.ml' --include='extract/v4/*.v' --include='extract/set2/' --include='extract/set2/Ext.v' --include='extract/set2/main.ml' --include='run_sort3.sh' --include='TOOLS.md' --include='NOTES.md' --exclude='*'
cp_tree x86      $ROOT/agents/x86    --include='*.sh' --include='*.py' --include='*.c' --include='*.h' --include='REPORT.md' --include='build/' --include='build/bench.h' --include='src/***' --exclude='*'
mkdir -p $S/x86/data; cp $ROOT/agents/x86/build/acl2_team_dump.txt $S/x86/data/
mkdir -p $S/proofs/vendor; cp $ROOT/agents/proofs/vendor/lrat-tool $S/proofs/vendor/   # frozen lean-lrat v1 binary (CNF layout used by regcanon.py)
chmod -R u+w "$S"   # integrity is checked by SHA256SUMS, not by file modes
cp_tree upper    $ROOT/agents/upper  --include='src/' --include='src/sim.h' --include='src/mcmc.c' --exclude='*'
cd "$S" && find . -type f ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS
echo "snapshot: $(find "$S" -type f | wc -l) files, $(du -sh "$S" | cut -f1); SHA256SUMS sha256 $(sha256sum SHA256SUMS | cut -c1-16)"
