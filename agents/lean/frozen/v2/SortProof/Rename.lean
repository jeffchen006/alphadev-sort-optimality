import SortProof.Relax
/-
  Register-bound lemma (MODEL.md section 1, "R = n + k").
  * `relaxed_rename` : register renaming that fixes `P0..P{n-1}`, keeps scratch as scratch and
                       never merges a written register with another used register keeps
                       relaxed correctness (also `strict_rename` for the strict model).
  * `compact`        : explicit renaming; written scratch registers get `S0, S1, ...` in order,
                       all never-written scratch registers share one register.
  * `register_bound` : n ≥ 2, relaxed-correct program of length k ⇒ the renamed program
                       (same length, same opcodes) uses only registers `< n + k`.
  * `pad`            : `mov P0, P0` is a no-op, so length < k reduces to length = k.
  * `lower_bound_chain` : no relaxed-correct program of length k on n + k registers ⇒
                       no program of length ≤ k, any registers, is correct on x86.
-/
namespace SortProof

def Instr.rename (ρ : Nat → Nat) : Instr → Instr
  | .mov d s => .mov (ρ d) (ρ s)
  | .cmp a b => .cmp (ρ a) (ρ b)
  | .cmov c d s => .cmov c (ρ d) (ρ s)

def Program.rename (ρ : Nat → Nat) (p : Program) : Program := p.map (Instr.rename ρ)

/-- Registers that matter: the inputs/outputs and every register in the program. -/
def Used (n : Nat) (p : Program) (r : Nat) : Prop := r < n ∨ ∃ i ∈ p, r ∈ i.regs

/-- Conditions on a renaming. -/
structure GoodRen (n : Nat) (p : Program) (ρ : Nat → Nat) : Prop where
  fixP : ∀ r < n, ρ r = r
  noMerge : ∀ i ∈ p, ∀ w, i.dest? = some w → ∀ r, Used n p r → ρ w = ρ r → w = r

/-- Simulation invariant: the renamed state at `ρ r` equals the original state at `r`. -/
def Sim (U : Nat → Prop) (ρ : Nat → Nat) (s' s : State Int) : Prop :=
  (∀ r, U r → s'.regs (ρ r) = s.regs r) ∧ s'.flag = s.flag

theorem step_sim {U : Nat → Prop} {ρ : Nat → Nat} {s' s : State Int} {i : Instr}
    (hU : ∀ r ∈ i.regs, U r)
    (hw : ∀ w, i.dest? = some w → ∀ r, U r → ρ w = ρ r → w = r)
    (h : Sim U ρ s' s) : Sim U ρ (step compare s' (i.rename ρ)) (step compare s i) := by
  obtain ⟨hr, hf⟩ := h
  have wr : ∀ d src, U d → U src → ρ d = ρ d → (∀ r, U r → ρ d = ρ r → d = r) →
      ∀ r, U r → upd s'.regs (ρ d) (s'.regs (ρ src)) (ρ r) = upd s.regs d (s.regs src) r := by
    intro d src hd hs _ hinj r hru
    simp only [upd]
    by_cases e : r = d
    · subst e; simp [hr _ hs]
    · have : ρ r ≠ ρ d := fun h' => e (hinj r hru h'.symm).symm
      simp [e, this, hr r hru]
  cases i with
  | mov d src =>
    have hd := hU d (by simp [Instr.regs]); have hs := hU src (by simp [Instr.regs])
    exact ⟨wr d src hd hs rfl (hw d rfl), hf⟩
  | cmp a b =>
    have ha := hU a (by simp [Instr.regs]); have hb := hU b (by simp [Instr.regs])
    refine ⟨hr, ?_⟩
    show compare (s'.regs (ρ a)) (s'.regs (ρ b)) = compare (s.regs a) (s.regs b)
    rw [hr a ha, hr b hb]
  | cmov c d src =>
    have hd := hU d (by simp [Instr.regs]); have hs := hU src (by simp [Instr.regs])
    simp only [Instr.rename, step, hf]
    split
    · exact ⟨wr d src hd hs rfl (hw d rfl), rfl⟩
    · exact ⟨hr, hf⟩

theorem run_sim {U : Nat → Prop} {ρ : Nat → Nat} (q : Program)
    (hU : ∀ i ∈ q, ∀ r ∈ i.regs, U r)
    (hw : ∀ i ∈ q, ∀ w, i.dest? = some w → ∀ r, U r → ρ w = ρ r → w = r)
    (s' s : State Int) (h : Sim U ρ s' s) :
    Sim U ρ (run compare (q.rename ρ) s') (run compare q s) := by
  induction q generalizing s' s with
  | nil => exact h
  | cons i q ih =>
    simp only [Program.rename, List.map_cons, run_cons]
    exact ih (fun j hj => hU j (by simp [hj])) (fun j hj => hw j (by simp [hj])) _ _
      (step_sim (hU i (by simp)) (hw i (by simp)) h)

theorem rename_out {n : Nat} {p : Program} {ρ : Nat → Nat} (hρ : GoodRen n p ρ) (s' : State Int) :
    let s : State Int := ⟨fun r => s'.regs (ρ r), s'.flag⟩
    ∀ j < n, (run compare (p.rename ρ) s').regs j = (run compare p s).regs j := by
  intro s j hj
  have h := run_sim (U := Used n p) p (fun i hi r hr => Or.inr ⟨i, hi, hr⟩) hρ.noMerge s' s
    ⟨fun _ _ => rfl, rfl⟩
  have := h.1 j (Or.inl hj)
  rw [hρ.fixP j hj] at this
  exact this

theorem strict_rename {n : Nat} {p : Program} {ρ : Nat → Nat} (hρ : GoodRen n p ρ)
    (h : StrictCorrect n p) : StrictCorrect n (p.rename ρ) := by
  intro s'
  have := h ⟨fun r => s'.regs (ρ r), s'.flag⟩
  refine (sortsOK_congr (fun i hi => ?_) (fun j hj => (rename_out hρ s' j hj).symm)).mp this
  show s'.regs (ρ i) = s'.regs i
  rw [hρ.fixP i hi]

theorem relaxed_rename {n : Nat} {p : Program} {ρ : Nat → Nat} (hρ : GoodRen n p ρ)
    (hS : ∀ r, n ≤ r → n ≤ ρ r) (h : RelaxedCorrect n p) : RelaxedCorrect n (p.rename ρ) := by
  intro x T hx
  have e : (⟨fun r => (relaxInit n x T).regs (ρ r), (relaxInit n x T).flag⟩ : State Int) =
      relaxInit n x T := by
    simp only [relaxInit]
    congr 1; funext r
    by_cases hr : r < n
    · simp [hr, hρ.fixP r hr]
    · have := hS r (by omega)
      have : ¬ ρ r < n := by omega
      simp [hr, this]
  have h1 := h x T hx
  refine (sortsOK_congr (fun _ _ => rfl) (fun j hj => ?_)).mp h1
  have := rename_out hρ (relaxInit n x T) j hj
  rw [e] at this
  exact this.symm

/-! ### The compacting renaming -/

/-- Destinations `≥ n`, one entry per instruction (duplicates kept; `idxOf` takes the first). -/
def scratchDests (n : Nat) : Program → List Nat
  | [] => []
  | i :: p => match i.dest? with
    | some d => if n ≤ d then d :: scratchDests n p else scratchDests n p
    | none => scratchDests n p

/-- Number of instructions with a destination `< n`. -/
def pDests (n : Nat) : Program → Nat
  | [] => 0
  | i :: p => match i.dest? with
    | some d => if d < n then pDests n p + 1 else pDests n p
    | none => pDests n p

theorem scratchDests_len (n : Nat) (p : Program) :
    (scratchDests n p).length + pDests n p ≤ p.length := by
  induction p with
  | nil => simp [scratchDests, pDests]
  | cons i p ih =>
    simp only [scratchDests, pDests, List.length_cons]
    cases i.dest? with
    | none => simp; omega
    | some d =>
      by_cases h : n ≤ d
      · have : ¬ d < n := by omega
        simp [h, this]; omega
      · have : d < n := by omega
        simp [h, this]; omega

theorem mem_scratchDests {n : Nat} {p : Program} {i : Instr} (hi : i ∈ p) {w : Nat}
    (hw : i.dest? = some w) (hn : n ≤ w) : w ∈ scratchDests n p := by
  induction p with
  | nil => simp at hi
  | cons j p ih =>
    simp only [scratchDests]
    rcases List.mem_cons.mp hi with rfl | hi'
    · rw [hw]; simp [hn]
    · have := ih hi'
      cases j.dest? with
      | none => exact this
      | some d => by_cases h : n ≤ d <;> simp [h, this]

def compact (n : Nat) (p : Program) (r : Nat) : Nat :=
  if r < n then r else n + (scratchDests n p).idxOf r

/-- `compact` never merges a written register with any other register. -/
theorem compact_noMerge (n : Nat) (p : Program) :
    ∀ i ∈ p, ∀ w, i.dest? = some w → ∀ r, compact n p w = compact n p r → w = r := by
  intro i hi w hw r he
  simp only [compact] at he
  by_cases hwn : w < n
  · by_cases hrn : r < n
    · rw [if_pos hwn, if_pos hrn] at he; exact he
    · rw [if_pos hwn, if_neg hrn] at he; omega
  · have hmem := mem_scratchDests (n := n) hi hw (by omega)
    have hlt := List.idxOf_lt_length_of_mem hmem
    by_cases hrn : r < n
    · rw [if_neg hwn, if_pos hrn] at he; omega
    · rw [if_neg hwn, if_neg hrn] at he
      have e : (scratchDests n p).idxOf w = (scratchDests n p).idxOf r := by omega
      have hr' : r ∈ scratchDests n p := List.idxOf_lt_length_iff.mp (e ▸ hlt)
      have h1 := List.getElem_idxOf (List.idxOf_lt_length_of_mem hmem)
      have h2 := List.getElem_idxOf (List.idxOf_lt_length_of_mem hr')
      have h3 : ∀ (l : List Nat) (a b : Nat) (ha : a < l.length) (hb : b < l.length), a = b →
          l[a] = l[b] := by intro l a b _ _ h; subst h; rfl
      exact h1.symm.trans ((h3 _ _ _ _ _ e).trans h2)

theorem compact_good (n : Nat) (p : Program) : GoodRen n p (compact n p) :=
  ⟨fun r hr => by simp [compact, hr], fun i hi w hw r _ he => compact_noMerge n p i hi w hw r he⟩

theorem compact_scratch (n : Nat) (p : Program) : ∀ r, n ≤ r → n ≤ compact n p r := by
  intro r hr; unfold compact; rw [if_neg (by omega)]; omega

theorem compact_bound (n : Nat) (p : Program) (r : Nat) :
    compact n p r ≤ n + (scratchDests n p).length := by
  simp only [compact]
  split
  · omega
  · have := List.idxOf_le_length (a := r) (l := scratchDests n p); omega

/-- A program with no destination `< n` leaves the outputs unchanged. -/
theorem run_noP {n : Nat} (p : Program) (hp : pDests n p = 0) (s : State Int) :
    ∀ j < n, (run compare p s).regs j = s.regs j := by
  induction p generalizing s with
  | nil => intro j _; rfl
  | cons i p ih =>
    intro j hj
    simp only [run_cons]
    have hp' : pDests n p = 0 ∧ (∀ d, i.dest? = some d → n ≤ d) := by
      simp only [pDests] at hp
      cases h : i.dest? with
      | none => rw [h] at hp; exact ⟨hp, by simp⟩
      | some d =>
        rw [h] at hp
        by_cases hd : d < n
        · simp [hd] at hp
        · simp [hd] at hp; exact ⟨hp, by intro d' e; cases e; omega⟩
    rw [ih hp'.1 _ j hj]
    cases i with
    | mov d src =>
      have := hp'.2 d rfl
      simp [step, upd]; omega
    | cmp a b => rfl
    | cmov c d src =>
      have := hp'.2 d rfl
      simp only [step]; split
      · simp [upd]; omega
      · rfl

theorem relaxed_writes_P {n : Nat} {p : Program} (hn : 2 ≤ n) (h : RelaxedCorrect n p) :
    0 < pDests n p := by
  apply Nat.pos_of_ne_zero
  intro h0
  -- inputs x0 = 1, x1 = 0, others 0, all < T = 2
  let x : Nat → Int := fun r => if r = 0 then 1 else 0
  have hc := h x 2 (fun i _ => by simp only [x]; split <;> omega)
  have hout := run_noP p h0 (relaxInit n x 2)
  have hs : SortsOK n x x := (sortsOK_congr (fun _ _ => rfl)
    (fun j hj => by rw [hout j hj]; simp [relaxInit, hj])).mp hc
  unfold SortsOK at hs
  have hpw := List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
    (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega)
    ((List.range n).map x)
  rw [← hs] at hpw
  have := List.pairwise_iff_getElem.mp hpw 0 1 (by simp; omega) (by simp; omega) (by omega)
  simp [x] at this

/-- Register-bound lemma. -/
theorem register_bound {n : Nat} {p : Program} (hn : 2 ≤ n) (h : RelaxedCorrect n p) :
    let p' := p.rename (compact n p)
    p'.length = p.length ∧ Program.WF (n + p.length) p' ∧ RelaxedCorrect n p' ∧
      (∀ iset : Cond → Bool, (∀ i ∈ p, i.inSet iset) → ∀ i ∈ p', i.inSet iset) := by
  intro p'
  have hlen := scratchDests_len n p
  have hP := relaxed_writes_P hn h
  refine ⟨by simp [p', Program.rename], ?_, relaxed_rename (compact_good n p) (compact_scratch n p) h, ?_⟩
  · intro i hi r hr
    simp only [p', Program.rename, List.mem_map] at hi
    obtain ⟨j, _, rfl⟩ := hi
    have hb : ∀ q, compact n p q < n + p.length := fun q => by
      have := compact_bound n p q; omega
    cases j <;> simp [Instr.rename, Instr.regs] at hr <;> rcases hr with rfl | rfl <;> exact hb _
  · intro iset hall i hi
    simp only [p', Program.rename, List.mem_map] at hi
    obtain ⟨j, hj, rfl⟩ := hi
    have := hall j hj
    cases j <;> simpa [Instr.rename, Instr.inSet] using this

/-! ### Padding -/

def pad (p : Program) (m : Nat) : Program := p ++ List.replicate m (.mov 0 0)

theorem run_pad (p : Program) (m : Nat) (s : State Int) :
    run compare (pad p m) s = run compare p s := by
  simp only [pad, run_append]
  generalize run compare p s = t
  induction m generalizing t with
  | zero => rfl
  | succ m ih =>
    simp only [List.replicate_succ, run_cons]
    have : step compare t (.mov 0 0) = t := by
      simp only [step]; congr 1; funext r; simp only [upd]; split <;> simp_all
    rw [this, ih]

theorem relaxed_pad {n : Nat} {p : Program} (m : Nat) (h : RelaxedCorrect n p) :
    RelaxedCorrect n (pad p m) := by
  intro x T hx; rw [run_pad]; exact h x T hx

/-- Lower-bound chain. Hypothesis = what the SAT/enumeration search checks: no program of
  length exactly `k` over the registers `0..n+k-1` with opcodes in `iset` is correct in the
  relaxed model. Conclusion: no program of length `≤ k` (any registers) with opcodes in `iset`
  is correct on x86 (all 32-bit inputs, all garbage, all flag states). -/
theorem lower_bound_chain (n k : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ p : Program, p.length = k → Program.WF (n + k) p → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedCorrect n p) :
    ∀ p : Program, p.length ≤ k → (∀ i ∈ p, i.inSet iset) → ¬ XCorrect n p := by
  intro p hk hset hx
  have hr := xcorrect_to_relaxed hn' hx
  let q := pad p (k - p.length)
  have hq : RelaxedCorrect n q := relaxed_pad _ hr
  have hqlen : q.length = k := by simp [q, pad]; omega
  have hqset : ∀ i ∈ q, i.inSet iset := by
    intro i hi
    simp only [q, pad, List.mem_append, List.mem_replicate] at hi
    rcases hi with hi | ⟨_, rfl⟩
    · exact hset i hi
    · rfl
  obtain ⟨h1, h2, h3, h4⟩ := register_bound hn hq
  rw [hqlen] at h2
  exact H _ (h1.trans hqlen) h2 (h4 iset hqset) h3

end SortProof
