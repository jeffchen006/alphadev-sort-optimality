import SortProof.L5
/-
  L5 in the STRICT semantics (theory CERT_OBLIGATIONS.md: needed for NG-based certificates).
  The translation `l5prog` of L5.lean is a simulation for EVERY initial state (`l5_sim`), so the same
  program p and snapshots o work in the relaxed and in the strict semantics.
  * `l5_strict`      : MMProg n q → XCorrect n q → ∃ p o, |p| + 2n ≤ |q| ∧ (opcodes kept) ∧ XSnap n p o.
  * `l5_strict_int`  : the same with StrictCorrect / StrictSnap (unbounded Int values).
  * `mm_lower_bound_strict` : (∀ p o, |p| ≤ K → ¬ XSnap n p o) → no MM program of length ≤ K + 2n is XCorrect.
-/
namespace SortProof

/-- The translated program's snapshots equal the final cells of `q`, for every initial state. -/
theorem l5_sim {n : Nat} {q : Program} (hq : MMProg n q) (init : State Int) :
    ∀ j < n, snapOut (l5prog n q).out (l5prog n q).snap init j = (run compare q init).regs j := by
  intro j hj
  have hinv := inv_run (init := init) q (t0 (maxReg q + n + 1)) init hq
    (fun i hi r hr => by have := regs_lt_maxReg i hi r hr; omega)
    (inv_init n (maxReg q + n + 1) (by omega) q init)
  obtain ⟨_, hv⟩ := hinv.i4 j hj (by simp [storeAhead])
  simp only [snapOut]
  exact hv

theorem l5_len {n : Nat} {q : Program} (hn : 2 ≤ n) (hq : MMProg n q) (h : RelaxedCorrect n q) :
    (l5prog n q).out.length + 2 * n ≤ q.length := by
  have h1 := tr_len q (t0 (maxReg q + n + 1)) hq
  have h2 := sumTo_ge n 2 _ (savedI_ge2 hn hq h)
  have h0 : (t0 (maxReg q + n + 1)).out.length = 0 := rfl
  rw [h0] at h1
  show (tr n (t0 (maxReg q + n + 1)) q).out.length + 2 * n ≤ q.length
  rw [Nat.mul_comm]; omega

theorem l5_iset {n : Nat} {q : Program} (iset : Cond → Bool) (hset : ∀ i ∈ q, i.inSet iset) :
    ∀ i ∈ (l5prog n q).out, i.inSet iset :=
  tr_inSet iset n q _ hset (by simp [t0])

/-- Strict L5 over unbounded `Int` values. -/
theorem l5_strict_int {n : Nat} {q : Program} (hn : 2 ≤ n) (hq : MMProg n q) (h : StrictCorrect n q) :
    ∃ (p : Program) (o : Snap), p.length + 2 * n ≤ q.length ∧
      (∀ iset : Cond → Bool, (∀ i ∈ q, i.inSet iset) → ∀ i ∈ p, i.inSet iset) ∧ StrictSnap n p o := by
  refine ⟨(l5prog n q).out, (l5prog n q).snap, l5_len hn hq (strict_to_relaxed h),
    fun iset hset => l5_iset iset hset, fun s => ?_⟩
  exact (sortsOK_congr (fun _ _ => rfl) (fun j hj => (l5_sim hq s j hj).symm)).mp (h s)

/-- Strict L5 on x86 (theory's statement). -/
theorem l5_strict {n : Nat} {q : Program} (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1) (hq : MMProg n q)
    (h : XCorrect n q) :
    ∃ (p : Program) (o : Snap), p.length + 2 * n ≤ q.length ∧
      (∀ iset : Cond → Bool, (∀ i ∈ q, i.inSet iset) → ∀ i ∈ p, i.inSet iset) ∧ XSnap n p o := by
  refine ⟨(l5prog n q).out, (l5prog n q).snap, l5_len hn hq (xcorrect_to_relaxed hn' h),
    fun iset hset => l5_iset iset hset, fun xs => ?_⟩
  have hc := h xs
  have e : (fun r => ((xrun q xs).regs r).toInt) = (run compare q xs.abs).regs :=
    congrArg State.regs (xrun_abs q xs)
  rw [e] at hc
  rw [xsnapOut_abs]
  exact (sortsOK_congr (fun _ _ => rfl) (fun j hj => (l5_sim hq xs.abs j hj).symm)).mp hc

/-- Strict-route chain to MM: a strict RS lower bound at K gives the MM bound K + 2n. -/
theorem mm_lower_bound_strict (n K : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ (p : Program) (o : Snap), p.length ≤ K → (∀ i ∈ p, i.inSet iset) → ¬ XSnap n p o) :
    ∀ q : Program, MMProg n q → q.length ≤ K + 2 * n → (∀ i ∈ q, i.inSet iset) → ¬ XCorrect n q := by
  intro q hmm hlen hset hx
  obtain ⟨p, o, hl, hs, hp⟩ := l5_strict hn hn' hmm hx
  exact H p o (by omega) (hs iset hset) hp

/-- Same, with the `StrictSnap` (Int) hypothesis form. -/
theorem mm_lower_bound_strict_int (n K : Nat) (iset : Cond → Bool) (hn : 2 ≤ n)
    (H : ∀ (p : Program) (o : Snap), p.length ≤ K → (∀ i ∈ p, i.inSet iset) → ¬ StrictSnap n p o) :
    ∀ q : Program, MMProg n q → q.length ≤ K + 2 * n → (∀ i ∈ q, i.inSet iset) → ¬ StrictCorrect n q := by
  intro q hmm hlen hset hs
  obtain ⟨p, o, hl, hi, hp⟩ := l5_strict_int hn hmm hs
  exact H p o (by omega) (hi iset hset) hp

end SortProof
