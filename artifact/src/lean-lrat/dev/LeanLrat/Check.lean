import Std.Tactic.BVDecide
import LeanLrat.Hcmp
import SortProof.L5
/-
  Glue to the verified LRAT checker of Lean core (`Std.Tactic.BVDecide.Reflect.verifyCert`,
  proved sound by `verifyCert_correct`). `checkCert` is a closed `Bool` computation; a result
  file proves `checkCert ... = true` by `native_decide`.
-/
namespace LeanLrat
open Std.Sat SortProof

def checkCert (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (cert : String) : Bool :=
  layoutOK n k i1 canon types && Std.Tactic.BVDecide.Reflect.verifyCert (enc n k i1 canon types) cert

theorem eval_decode_layout (d : Dims) (b : Array Nat) (a : V → Bool) (c : CNF.Clause V)
    (h : (c.all fun l => decode d b (layout d b l.1) == l.1) = true) :
    CNF.Clause.eval (a ∘ decode d b ∘ layout d b) c = CNF.Clause.eval a c := by
  induction c with
  | nil => rfl
  | cons l c ih =>
    simp only [List.all_cons, Bool.and_eq_true, beq_iff_eq] at h
    simp only [CNF.Clause.eval_cons, Function.comp, h.1, ih h.2]

theorem encV_unsat_of_enc_unsat (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm hc : Bool)
    (hL : layoutOK n k i1 canon types norm hc = true) (hU : (enc n k i1 canon types norm hc).Unsat) :
    (encV n k i1 canon types norm hc).Unsat := by
  intro a
  have := hU (a ∘ decode (dimsOf n k types) (dimsOf n k types).bases)
  rw [enc, CNF.eval_relabel] at this
  rw [encV_eval n k i1 canon types norm hc] at this ⊢
  have key : ∀ c ∈ encList n k i1 canon types norm hc, CNF.Clause.eval
      ((a ∘ decode (dimsOf n k types) (dimsOf n k types).bases) ∘
        layout (dimsOf n k types) (dimsOf n k types).bases) c = CNF.Clause.eval a c :=
    fun c hc => by
      exact eval_decode_layout _ _ _ _ (List.all_eq_true.mp hL c hc)
  rw [← this]
  apply Bool.eq_iff_iff.mpr
  simp only [List.all_eq_true]
  exact ⟨fun h c hc => (key c hc).trans (h c hc), fun h c hc => (key c hc).symm.trans (h c hc)⟩

theorem unsat_of_checkCert (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (cert : String)
    (h : checkCert n k i1 canon types cert = true) : (encV n k i1 canon types).Unsat := by
  simp only [checkCert, Bool.and_eq_true] at h
  exact encV_unsat_of_enc_unsat n k i1 canon types false false h.1
    (Std.Tactic.BVDecide.Reflect.verifyCert_correct _ _ h.2)

/-- A checked certificate gives the search hypothesis `H` of `SortProof.lower_bound_chain_snap`. -/
theorem H_of_checkCert (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (cert : String)
    (h : checkCert n k i1 canon types cert = true) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o :=
  sound n k i1 canon types (unsat_of_checkCert n k i1 canon types cert h)

/-! ### Cube splitting: one certificate per cube, combined in the kernel -/

/-- `f` with one unit clause per literal of `us`. -/
def addUnits (f : CNF Nat) (us : List (Nat × Bool)) : CNF Nat := us.foldl (fun g u => g.add [u]) f

theorem addUnits_snoc (f : CNF Nat) (us : List (Nat × Bool)) (u : Nat × Bool) :
    addUnits f (us ++ [u]) = (addUnits f us).add [u] := by
  simp [addUnits, List.foldl_append]

/-- Binary split on variable `v`. -/
theorem unsat_split (f : CNF Nat) (us : List (Nat × Bool)) (v : Nat)
    (h1 : (addUnits f (us ++ [(v, true)])).Unsat) (h2 : (addUnits f (us ++ [(v, false)])).Unsat) :
    (addUnits f us).Unsat := by
  intro a
  rw [addUnits_snoc] at h1 h2
  have e1 := h1 a
  have e2 := h2 a
  simp only [CNF.eval_add, CNF.Clause.eval_cons, CNF.Clause.eval_nil, Bool.or_false] at e1 e2
  cases hv : a v <;> simp_all

theorem unsat_of_cube_cert (f : CNF Nat) (us : List (Nat × Bool)) (cert : String)
    (h : Std.Tactic.BVDecide.Reflect.verifyCert (addUnits f us) cert = true) : (addUnits f us).Unsat :=
  Std.Tactic.BVDecide.Reflect.verifyCert_correct _ _ h

theorem H_of_unsat (n k : Nat) (i1 canon : Bool) (types : List (List Nat))
    (hL : layoutOK n k i1 canon types = true) (hU : (addUnits (enc n k i1 canon types) []).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o :=
  sound n k i1 canon types (encV_unsat_of_enc_unsat n k i1 canon types false false hL hU)

/-- Like `H_of_unsat`, for the encoding with both rules (first-touch + normal form, `I1n`). -/
theorem H_of_unsat_norm (n k : Nat) (i1 : Bool) (types : List (List Nat)) (hn : 2 ≤ n)
    (hL : layoutOK n k i1 true types true = true) (hU : (addUnits (enc n k i1 true types true) []).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o :=
  sound_norm n k i1 types hn (encV_unsat_of_enc_unsat n k i1 true types true false hL hU)

/-! ### With the hcmp cut (types must be distinct permutations) -/

def isPermRowB (n : Nat) (row : List Nat) : Bool :=
  row.length == n && decide row.Nodup && row.all (fun v => decide (v < n)) &&
    (List.range n).all (fun v => row.contains v)

def permOK (n : Nat) (types : List (List Nat)) : Bool := decide types.Nodup && types.all (isPermRowB n)

theorem permOK_sound (n : Nat) (types : List (List Nat)) (h : permOK n types = true) : PermTypes n types := by
  simp only [permOK, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true] at h
  refine ⟨h.1, fun row hr => ?_⟩
  have := h.2 row hr
  simp only [isPermRowB, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq, List.all_eq_true,
    List.mem_range, List.contains_iff_mem] at this
  exact ⟨this.1.1.1, this.1.1.2, this.1.2, this.2⟩

theorem H_of_unsat_hc (n k : Nat) (i1 : Bool) (types : List (List Nat)) (hP : permOK n types = true)
    (hL : layoutOK n k i1 true types false true = true)
    (hU : (addUnits (enc n k i1 true types false true) []).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o :=
  sound_gen n k i1 true types true
    (fun _ q o hl ho hq => hcmpCls_sat n k types q o (permOK_sound n types hP) hl ho hq)
    (encV_unsat_of_enc_unsat n k i1 true types false true hL hU)

theorem H_of_unsat_norm_hc (n k : Nat) (i1 : Bool) (types : List (List Nat)) (hn : 2 ≤ n)
    (hP : permOK n types = true)
    (hL : layoutOK n k i1 true types true true = true)
    (hU : (addUnits (enc n k i1 true types true true) []).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o :=
  sound_norm_gen n k i1 types hn true
    (fun _ q o hl ho hq => hcmpCls_sat n k types q o (permOK_sound n types hP) hl ho hq)
    (encV_unsat_of_enc_unsat n k i1 true types true true hL hU)

end LeanLrat
