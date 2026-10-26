import LeanLrat.Check
/- One certificate: cnf/n3_I1nh_k10_perm.lrat (cadical 3.0.1, trimmed by Lean's LRAT.trim).
   CNF: enc 3 10 (i1 := true) (canon := true) types (norm := true) (hc := true), types = the 6 permutations. -/
open LeanLrat SortProof

def types3 : List (List Nat) := [[0,1,2],[0,2,1],[1,0,2],[1,2,0],[2,0,1],[2,1,0]]

def cert_s3k10 : String := include_str "../cnf/n3_I1nh_k10_perm.lrat"

theorem perm3 : permOK 3 types3 = true := by native_decide
theorem layout3 : layoutOK 3 10 true true types3 true true = true := by native_decide
theorem unsat3 : (addUnits (enc 3 10 true true types3 true true) []).Unsat :=
  unsat_of_cube_cert _ _ cert_s3k10 (by native_decide)

/-- No x86-64 program with at most 10 mov/cmp/cmovl/cmovg/cmovle/cmovge (any registers, free snapshot
  outputs, M_out) sorts 3 signed 32-bit inputs for all garbage values and flag states. -/
theorem sort3_I1_no_le10 : ∀ (p : Program) (o : Snap), p.length ≤ 10 →
    (∀ i ∈ p, i.inSet (isetOf true)) → ¬ XSnap 3 p o :=
  lower_bound_chain_snap 3 10 (isetOf true) (by decide) (by decide)
    (H_of_unsat_norm_hc 3 10 true types3 (by decide) perm3 layout3 unsat3)

/-- Memory model M_AD (every instruction counts incl. loads/stores, lean L5): AlphaDev's sort3 (17) is optimal. -/
theorem sort3_I1_MM_no_le16 : ∀ q : Program, MMProg 3 q → q.length ≤ 10 + 2 * 3 →
    (∀ i ∈ q, i.inSet (isetOf true)) → ¬ XCorrect 3 q :=
  mm_lower_bound 3 10 (isetOf true) (by decide) (by decide)
    (H_of_unsat_norm_hc 3 10 true types3 (by decide) perm3 layout3 unsat3)

#print axioms sort3_I1_no_le10
#print axioms sort3_I1_MM_no_le16
