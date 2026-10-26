#!/bin/bash
# CLAIM (coq 21:57): Rocq theorem CmovSort.SetList.lower_bound_set' (set model = enum's Lemma S formalized): sort3, no M_out
# program with k <= 10 for EVERY register count R >= n, I1, relaxed, strict perms; rules S, W, P, G, D, H1, und, H2, E3 proved;
# no Admitted; Print Assumptions = PrimInt63 primitives only. Premise checked by the extracted OCaml checker.
# Expected: "set model n=3 I1 k=10 scertifies=true". Time ~13 min + compile, 1 core.
source "$(dirname "$0")/../lib.sh"
W=$OUT/coq; rm -rf $W; cp -r $SRC/coq $W; cd $W
source $ROOT/agents/coq/tools/env.sh   # Rocq 9.3 / OCaml 4.14.2 toolchain (opam root of the coq agent)
cd src
for f in Machine Vec Good Prune Check Sound Inst Sort3 SetModel SetList; do run rocq compile -Q . CmovSort $f.v || FAILS=$((FAILS+1)); done
printf 'From CmovSort Require Import SetList.\nPrint Assumptions SetList.lower_bound_set%s.\n' "'" > PA.v
run rocq compile -Q . CmovSort PA.v
cd ../extract/set2; rm -f scheck3.ml scheck3.mli
run rocq compile -Q ../../src CmovSort Ext.v
run ocamlfind ocamlopt -O3 -package rocq-runtime.kernel,unix -linkpkg scheck3.mli scheck3.ml main.ml -o scheck3
run nice -n 10 ./scheck3 I1 10
expect "set model n=3 I1 k=10 scertifies=true"
grep -q "Admitted\|admit" $LOG && { say "Admitted found"; FAILS=$((FAILS+1)); }
finish
