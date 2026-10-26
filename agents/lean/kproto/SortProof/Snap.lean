import SortProof.Rename
/-
  RS model (theory lemmas.md §0.3, MODEL.md §4.3 `model=out`): snapshot outputs.
  A snapshot spec `o : Nat → Nat × Nat` gives, for output `j`, a register `(o j).1` and a position
  `(o j).2`: output `j` = value of that register after the first `(o j).2` instructions.
  The snapshots cost nothing. RF (§1, outputs in `P_j` at the end) is the case `o j = (j, |p|)`.

  * `xsnap_to_relaxed`    : x86-correct (all garbage, all flags) ⇒ relaxed-correct (scratch = T, flags = eq).
  * `relaxed_snap_has_cmp`: n ≥ 2, relaxed-correct ⇒ the program has a `cmp`.
  * `register_bound_snap` : relaxed-correct, length k ⇒ renamed program + snapshots on registers `< n + k`.
  * `lower_bound_chain_snap` : the RS chain (what `sat`/`enum` search ⇒ the x86 statement).
-/
namespace SortProof

abbrev Snap := Nat → Nat × Nat

def snapOut (p : Program) (o : Snap) (s : State Int) : Nat → Int :=
  fun j => (run compare (p.take (o j).2) s).regs (o j).1

def StrictSnap (n : Nat) (p : Program) (o : Snap) : Prop :=
  ∀ s : State Int, SortsOK n s.regs (snapOut p o s)

def RelaxedSnap (n : Nat) (p : Program) (o : Snap) : Prop :=
  ∀ (x : Nat → Int) (T : Int), (∀ i < n, x i < T) → SortsOK n x (snapOut p o (relaxInit n x T))

def xsnapOut (p : Program) (o : Snap) (s : XState) : Nat → Int :=
  fun j => ((xrun (p.take (o j).2) s).regs (o j).1).toInt

/-- RS correctness on x86: all 32-bit register files and all flag states. -/
def XSnap (n : Nat) (p : Program) (o : Snap) : Prop :=
  ∀ s : XState, SortsOK n (fun r => (s.regs r).toInt) (xsnapOut p o s)

theorem xsnapOut_abs (p : Program) (o : Snap) (s : XState) :
    xsnapOut p o s = snapOut p o s.abs := by
  funext j
  simp only [xsnapOut, snapOut, ← xrun_abs]
  rfl

theorem strictSnap_to_x86 {n : Nat} {p : Program} {o : Snap} (h : StrictSnap n p o) : XSnap n p o := by
  intro s
  rw [xsnapOut_abs]
  exact h s.abs

/-- Order-type transfer for a family of runs (one program per output). -/
theorem correct_transfer_family {n : Nat} (q : Nat → Program) (o : Nat → Nat) (u v : State Int)
    (hflag : u.flag = v.flag)
    (hord : ∀ i j, compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    SortsOK n u.regs (fun j => (run compare (q j) u).regs (o j)) ↔
      SortsOK n v.regs (fun j => (run compare (q j) v).regs (o j)) := by
  have ho : oracleOf u.regs = oracleOf v.regs := by funext i j; exact hord i j
  have hu : (fun j => (run compare (q j) u).regs (o j)) =
      fun j => u.regs ((run (oracleOf u.regs) (q j) (symInit u.flag)).regs (o j)) :=
    funext fun j => by rw [run_eq_sym]; rfl
  have hv : (fun j => (run compare (q j) v).regs (o j)) =
      fun j => v.regs ((run (oracleOf u.regs) (q j) (symInit u.flag)).regs (o j)) :=
    funext fun j => by rw [run_eq_sym, ← ho, ← hflag]; rfl
  rw [hu, hv]
  exact sortsOK_transferQ (fun _ => True) (fun _ _ => trivial) u.regs v.regs _
    (fun _ _ => trivial) (fun i j _ _ => hord i j)

/-- Relaxation lemma for RS. -/
theorem xsnap_to_relaxed {n : Nat} {p : Program} {o : Snap} (hn : n < 2 ^ 31 - 1)
    (h : XSnap n p o) : RelaxedSnap n p o := by
  intro x T hx
  let c := rankList x n
  let xin : Nat → BitVec 32 := fun r => BitVec.ofInt 32 (vecRegs c r)
  have hc : ∀ r, 0 ≤ vecRegs c r ∧ vecRegs c r < 2 ^ 31 - 1 := by
    intro r
    simp only [vecRegs, List.getD_eq_getElem?_getD]
    cases hr : c[r]? with
    | none => simp
    | some y =>
      have hy := List.mem_of_getElem? hr
      have := ((mem_allVecs n n c).mp (List.mem_filter.mp (rankList_mem_reps x n)).1).2 y hy
      simp
      omega
  have hxin : ∀ r, (xin r).toInt = vecRegs c r := fun r =>
    toInt_ofInt_small _ (hc r).1 (by have := (hc r).2; omega)
  have habs : (xRelaxInit n xin).abs = relaxInit n (vecRegs c) (2 ^ 31 - 1) := by
    simp only [XState.abs, XState.flagOrd, xRelaxInit, relaxInit]
    congr 1
    funext r
    by_cases hr : r < n
    · simp [hr, hxin]
    · simp only [hr, if_false]; exact toInt_ofInt_small _ (by decide) (by decide)
  have h1 := h (xRelaxInit n xin)
  rw [xsnapOut_abs, habs] at h1
  have e2 : (fun r => ((xRelaxInit n xin).regs r).toInt) = (relaxInit n (vecRegs c) (2 ^ 31 - 1)).regs := by
    have := congrArg State.regs habs; exact this
  rw [e2] at h1
  have hord : ∀ i j, i < n → j < n → compare (x i) (x j) = compare (vecRegs c i) (vecRegs c j) := by
    intro i j hi hj
    rw [vecRegs_rankList x hi, vecRegs_rankList x hj, rank_compare x hi hj]
  have key := correct_transfer_family (n := n) (fun j => p.take (o j).2) (fun j => (o j).1)
    (relaxInit n x T) (relaxInit n (vecRegs c) (2 ^ 31 - 1))
    rfl (relaxInit_order x (vecRegs c) T _ hx (fun i _ => (hc i).2) hord)
  have h2 := key.mpr h1
  exact (sortsOK_congr (fun i hi => by simp [relaxInit, hi]) (fun _ _ => rfl)).mp h2

/-! ### Any correct program has a `cmp` -/

def Instr.isCmp : Instr → Bool
  | .cmp _ _ => true
  | _ => false

theorem step_nocmp {α : Type} (o o' : α → α → Ordering) (s : State α) (i : Instr)
    (h : i.isCmp = false) : step o s i = step o' s i := by
  cases i <;> simp_all [Instr.isCmp, step]

theorem run_nocmp {α : Type} (o o' : α → α → Ordering) (p : Program)
    (h : ∀ i ∈ p, i.isCmp = false) (s : State α) : run o p s = run o' p s := by
  induction p generalizing s with
  | nil => rfl
  | cons i p ih =>
    simp only [run_cons]
    rw [step_nocmp o o' s i (h i (by simp))]
    exact ih (fun j hj => h j (by simp [hj])) _

/-- Output 0 of a correct run is `≤` every input. -/
theorem sortsOK_min {n : Nat} {x y : Nat → Int} (hn : 0 < n) (h : SortsOK n x y) :
    ∀ i < n, y 0 ≤ x i := by
  intro i hi
  unfold SortsOK at h
  have hs := List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
    (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega) ((List.range n).map x)
  rw [← h] at hs
  have hmem : x i ∈ (List.range n).map y := by
    rw [h]
    exact (List.mergeSort_perm _ _).mem_iff.mpr (List.mem_map.mpr ⟨i, by simpa using hi, rfl⟩)
  obtain ⟨m, hm, hme⟩ := List.mem_map.mp hmem
  have hm' : m < n := by simpa using hm
  rw [← hme]
  by_cases hm0 : m = 0
  · subst hm0; exact Int.le_refl _
  · have := List.pairwise_iff_getElem.mp hs 0 m (by simp; omega) (by simp; omega) (by omega)
    simpa using this

theorem relaxed_snap_has_cmp {n : Nat} {p : Program} {o : Snap} (hn : 2 ≤ n)
    (h : RelaxedSnap n p o) : ∃ i ∈ p, i.isCmp = true := by
  apply Classical.byContradiction
  intro hno
  have hnc : ∀ i ∈ p, i.isCmp = false := fun i hi => by
    cases e : i.isCmp
    · rfl
    · exact absurd ⟨i, hi, e⟩ hno
  -- the index of output 0 does not depend on the input
  let τ : (Nat → Int) → Nat := fun x =>
    (run (oracleOf (relaxInit n x 2).regs) (p.take (o 0).2) (symInit .eq)).regs (o 0).1
  have hτ : ∀ x x', τ x = τ x' := fun x x' => by
    simp only [τ]
    rw [run_nocmp _ (oracleOf (relaxInit n x' 2).regs) _
      (fun i hi => hnc i (List.mem_of_mem_take hi))]
  have hout : ∀ x, snapOut p o (relaxInit n x 2) 0 = (relaxInit n x 2).regs (τ x) := fun x => by
    simp only [snapOut, τ]; rw [run_eq_sym]; rfl
  let xA : Nat → Int := fun r => if r = 0 then 0 else 1
  let xB : Nat → Int := fun r => if r = 1 then 0 else 1
  have hA := h xA 2 (fun i _ => by simp only [xA]; split <;> omega)
  have hB := h xB 2 (fun i _ => by simp only [xB]; split <;> omega)
  have mA := sortsOK_min (by omega) hA 0 (by omega)
  have mB := sortsOK_min (by omega) hB 1 (by omega)
  rw [hout] at mA mB
  rw [hτ xB xA] at mB
  have eA : xA 0 = 0 := by simp [xA]
  have eB : xB 1 = 0 := by simp [xB]
  rw [eA] at mA
  rw [eB] at mB
  simp only [relaxInit] at mA mB
  by_cases h1 : τ xA < n
  · rw [if_pos h1] at mA mB
    simp only [xA, xB] at mA mB
    by_cases h2 : τ xA = 0
    · rw [if_neg (by omega : ¬ τ xA = 1)] at mB; omega
    · rw [if_neg h2] at mA; omega
  · rw [if_neg h1] at mA; omega

/-! ### Register bound and chain for RS -/

/-- Number of `cmp` instructions. -/
def nCmp : Program → Nat
  | [] => 0
  | i :: p => nCmp p + if i.isCmp then 1 else 0

theorem scratchDests_len_cmp (n : Nat) (p : Program) :
    (scratchDests n p).length + nCmp p ≤ p.length := by
  induction p with
  | nil => simp [scratchDests, nCmp]
  | cons i p ih =>
    cases i with
    | cmp a b => simp [scratchDests, nCmp, Instr.dest?, Instr.isCmp]; omega
    | mov d s =>
      simp only [scratchDests, nCmp, Instr.dest?, Instr.isCmp, List.length_cons]
      split <;> simp <;> omega
    | cmov c d s =>
      simp only [scratchDests, nCmp, Instr.dest?, Instr.isCmp, List.length_cons]
      split <;> simp <;> omega

theorem nCmp_pos {p : Program} (h : ∃ i ∈ p, i.isCmp = true) : 0 < nCmp p := by
  induction p with
  | nil => simp at h
  | cons j p ih =>
    obtain ⟨i, hi, hc⟩ := h
    simp only [nCmp]
    rcases List.mem_cons.mp hi with rfl | hi'
    · simp [hc]
    · have := ih ⟨i, hi', hc⟩; omega

theorem take_rename (ρ : Nat → Nat) (p : Program) (t : Nat) :
    (Program.rename ρ p).take t = Program.rename ρ (p.take t) := by
  simp [Program.rename, List.map_take]

theorem take_min (p : Program) (t : Nat) : p.take (min t p.length) = p.take t := by
  by_cases ht : t ≤ p.length
  · rw [Nat.min_eq_left ht]
  · rw [Nat.min_eq_right (by omega), List.take_of_length_le (by omega),
      List.take_of_length_le (by omega)]

theorem relaxed_snap_rename {n : Nat} {p : Program} {o : Snap} {ρ : Nat → Nat}
    (hfix : ∀ r < n, ρ r = r) (hS : ∀ r, n ≤ r → n ≤ ρ r)
    (hw : ∀ i ∈ p, ∀ w, i.dest? = some w → ∀ r, ρ w = ρ r → w = r)
    (h : RelaxedSnap n p o) :
    RelaxedSnap n (p.rename ρ) (fun j => (ρ (o j).1, (o j).2)) := by
  intro x T hx
  have e : (⟨fun r => (relaxInit n x T).regs (ρ r), (relaxInit n x T).flag⟩ : State Int) =
      relaxInit n x T := by
    simp only [relaxInit]
    congr 1; funext r
    by_cases hr : r < n
    · simp [hr, hfix r hr]
    · have := hS r (by omega)
      have : ¬ ρ r < n := by omega
      simp [hr, this]
  have h1 := h x T hx
  refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp h1
  simp only [snapOut]
  rw [take_rename]
  have hsim := run_sim (U := fun _ => True) (ρ := ρ) (p.take (o j).2) (fun _ _ _ _ => trivial)
    (fun i hi w hw' r _ he => hw i (List.mem_of_mem_take hi) w hw' r he)
    (relaxInit n x T) ⟨fun r => (relaxInit n x T).regs (ρ r), (relaxInit n x T).flag⟩
    ⟨fun _ _ => rfl, rfl⟩
  rw [e] at hsim
  exact (hsim.1 (o j).1 trivial).symm

/-- Register-bound lemma for RS: registers `< n + k`, snapshot positions `≤ k`. -/
theorem register_bound_snap {n : Nat} {p : Program} {o : Snap} (hn : 2 ≤ n) (h : RelaxedSnap n p o) :
    let p' := p.rename (compact n p)
    let o' : Snap := fun j => (compact n p (o j).1, min (o j).2 p.length)
    p'.length = p.length ∧ Program.WF (n + p.length) p' ∧ (∀ j, (o' j).1 < n + p.length) ∧
      (∀ j, (o' j).2 ≤ p.length) ∧ RelaxedSnap n p' o' ∧
      (∀ iset : Cond → Bool, (∀ i ∈ p, i.inSet iset) → ∀ i ∈ p', i.inSet iset) := by
  intro p' o'
  have hlen := scratchDests_len_cmp n p
  have hc := nCmp_pos (relaxed_snap_has_cmp hn h)
  have hb : ∀ q, compact n p q < n + p.length := fun q => by
    have := compact_bound n p q; omega
  -- clamp positions first (same semantics)
  have hcl : RelaxedSnap n p (fun j => ((o j).1, min (o j).2 p.length)) := by
    intro x T hx
    have := h x T hx
    refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp this
    simp only [snapOut, take_min]
  refine ⟨by simp [p', Program.rename], ?_, fun j => hb _, fun j => Nat.min_le_right _ _,
    relaxed_snap_rename (fun r hr => by simp [compact, hr]) (compact_scratch n p)
      (compact_noMerge n p) hcl, ?_⟩
  · intro i hi r hr
    simp only [p', Program.rename, List.mem_map] at hi
    obtain ⟨j, _, rfl⟩ := hi
    cases j <;> simp [Instr.rename, Instr.regs] at hr <;> rcases hr with rfl | rfl <;> exact hb _
  · intro iset hall i hi
    simp only [p', Program.rename, List.mem_map] at hi
    obtain ⟨j, hj, rfl⟩ := hi
    have := hall j hj
    cases j <;> simpa [Instr.rename, Instr.inSet] using this

theorem relaxed_snap_pad {n : Nat} {p : Program} {o : Snap} (m : Nat)
    (ho : ∀ j, (o j).2 ≤ p.length) (h : RelaxedSnap n p o) : RelaxedSnap n (pad p m) o := by
  intro x T hx
  have := h x T hx
  refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp this
  simp only [snapOut, pad, List.take_append_of_le_length (ho j)]

/-- Lower-bound chain for RS. Hypothesis = the search: no program of length exactly `k` on
  registers `< n + k`, with snapshots on registers `< n + k` at positions `≤ k`, opcodes in
  `iset`, is relaxed-correct. Conclusion: no program of length `≤ k` (any registers, any
  snapshots) with opcodes in `iset` is RS-correct on x86. -/
theorem lower_bound_chain_snap (n k : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedSnap n p o) :
    ∀ (p : Program) (o : Snap), p.length ≤ k → (∀ i ∈ p, i.inSet iset) → ¬ XSnap n p o := by
  intro p o hk hset hx
  have hr := xsnap_to_relaxed hn' hx
  -- clamp, pad, then compact
  let o1 : Snap := fun j => ((o j).1, min (o j).2 p.length)
  have hr1 : RelaxedSnap n p o1 := by
    intro x T hx'
    have := hr x T hx'
    refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp this
    simp only [snapOut, o1, take_min]
  let q := pad p (k - p.length)
  have hq : RelaxedSnap n q o1 := relaxed_snap_pad _ (fun j => Nat.min_le_right _ _) hr1
  have hqlen : q.length = k := by simp [q, pad]; omega
  have hqset : ∀ i ∈ q, i.inSet iset := by
    intro i hi
    simp only [q, pad, List.mem_append, List.mem_replicate] at hi
    rcases hi with hi | ⟨_, rfl⟩
    · exact hset i hi
    · rfl
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := register_bound_snap hn hq
  rw [hqlen] at h2 h3 h4 h5
  exact H _ _ (h1.trans hqlen) h2 h3 h4 (h6 iset hqset) h5

end SortProof
