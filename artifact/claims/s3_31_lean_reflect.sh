#!/bin/bash
# CLAIM (lean-reflect 19:55, statements reviewed by theory):
#   LeanReflect.sort3_x86_lb : ∀ p o, p.length ≤ 10 → ¬ XSnap 3 p o   (M_out, I1, registers = any Nat, x86 int32 strict)
#   LeanReflect.sort3_mm_lb  : AlphaDev's model, no sort3 with L ≤ 16 (= sort3_rs_lb + lean's mm_lower_bound / L5)
#   LeanReflect.Pos.p3_x86, p4_x86 : AlphaDev sort3 (k=11) and sort4 (k=20) M_out cores are XSnap-correct (kernel only)
# Proof of the bound = verified checker run by native_decide. Trust: Lean kernel + compiler (native_decide axiom).
# Expected axioms (lean-reflect, exact): lb theorems = [propext, Classical.choice, Quot.sound,
#   LeanReflect.sort3_rs_lb._native.native_decide.ax_1_1]; Pos theorems = [propext, Classical.choice, Quot.sound].
# Time: ~45-60 min on 1 core (native check uses 4 Tasks: 858 s on 4 cores); RAM < 2 GB.
source "$(dirname "$0")/../lib.sh"
mirror lean-reflect; W=$OUT/agents/lean-reflect; cd $W   # Positive.lean reads ../../../programs/out/*.s
run bash -c "grep -E '\\./SortProof(\\.lean|/)' $SRC/lean/frozen/v2/SHA256SUMS | sha256sum -c -"   # SortProof = lean frozen/v2
run $TS lake build LeanReflect.Sort3 LeanReflect.Sort3MM LeanReflect.Positive
printf 'import LeanReflect.Sort3MM\nimport LeanReflect.Positive\n#print axioms LeanReflect.sort3_x86_lb\n#print axioms LeanReflect.sort3_mm_lb\n#print axioms LeanReflect.Pos.p3_x86\n#print axioms LeanReflect.Pos.p4_x86\n' > ax.lean
$TS lake env lean ax.lean 2>&1 | tr -d '\n' | sed 's/\x27LeanReflect/\n&/g' | tr -s ' ' >> $LOG; echo >> $LOG
NAT='LeanReflect.sort3_rs_lb._native.native_decide.ax_1_1'
expect "'LeanReflect.sort3_x86_lb' depends on axioms: \[propext, ?Classical.choice, ?Quot.sound, ?$NAT\]"
expect "'LeanReflect.sort3_mm_lb' depends on axioms: \[propext, ?Classical.choice, ?Quot.sound, ?$NAT\]"
expect "'LeanReflect.Pos.p3_x86' depends on axioms: \[propext, ?Classical.choice, ?Quot.sound\]"
expect "'LeanReflect.Pos.p4_x86' depends on axioms: \[propext, ?Classical.choice, ?Quot.sound\]"
grep -q "sorryAx" $LOG && { say "sorry found"; FAILS=$((FAILS+1)); }
finish
