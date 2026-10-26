#!/bin/bash
# Rebuild the Coq proofs, extract the checker, run sort3 (n=3, R=3+k, M_out snapshots).
# usage: ./run_sort3.sh I1|I0 K      (K=10 takes ~20 min on 1 core, ~0.5 GB)
set -e
cd "$(dirname "$0")"
source tools/env.sh
cd src
for f in Machine Vec Good Prune Check Sound Inst Sort3; do rocq compile -Q . CmovSort $f.v; done
cd ../extract/v4
rm -f check3.ml check3.mli
rocq compile -Q ../../src CmovSort Ext.v
ocamlfind ocamlopt -O3 -package rocq-runtime.kernel,unix -linkpkg check3.mli check3.ml main3.ml -o check3
nice -n 10 ./check3 "$1" "$2"
