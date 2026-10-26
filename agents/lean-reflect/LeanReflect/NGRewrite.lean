import LeanReflect.NGDefs
/-
  Rule NG (theory L10), position-preserving form.
  `ngRewrite n p` rewrites `p` instruction by instruction; a deleted instruction becomes the no-op
  `mov 0 0`, so snapshot positions do not change. The set of accessed registers after a prefix is
  `accd n pre` of the emitted prefix `pre` (inputs and every register in `pre`).
  Main result `ng_rewrite`: an x86 RS-correct program has an NG-normal rewrite of the same length
  that is correct in the relaxed model with `T = n`.
-/
namespace LeanReflect.NGR
open SortProof

/-! ### The rewriter -/

/-- One step: emitted instruction and new eq-block bit (`true`: the flags of `p` are `eq`). -/
def ngStep (n : Nat) (pq : Program) (e : Bool) : Instr → Instr × Bool
  | .cmp a b =>
    if a = b then (if ¬ accd n pq a then (.mov 0 0, true) else (.cmp a a, false))
    else if ¬ accd n pq a ∧ ¬ accd n pq b then (.mov a b, true)
    else if ¬ accd n pq b then (.mov b a, true)
    else if ¬ accd n pq a then (.mov a b, true)
    else (.cmp a b, false)
  | .mov d s =>
    if d = s then (.mov 0 0, e)
    else if ¬ accd n pq d ∧ ¬ accd n pq s then (.mov d s, e)
    else if ¬ accd n pq s then (.mov s d, e)
    else (.mov d s, e)
  | .cmov c d s =>
    if d = s then (.mov 0 0, e)
    else if ¬ accd n pq d ∧ ¬ accd n pq s then (.mov d s, e)
    else if ¬ accd n pq d then (.mov d s, e)
    else if ¬ accd n pq s then (.mov s d, e)
    else if e then (if c.eval .eq then (.mov d s, e) else (.mov 0 0, e))
    else (.cmov c d s, e)

/-- Left fold: emitted prefix `pq`, eq-block bit `e`, rest of the input program. -/
def ngGo (n : Nat) : Program → Bool → Program → Program × Bool
  | pq, e, [] => (pq, e)
  | pq, e, i :: rest => ngGo n (pq ++ [(ngStep n pq e i).1]) (ngStep n pq e i).2 rest

def ngRewrite (n : Nat) (p : Program) : Program := (ngGo n [] false p).1

theorem ngGo_append (n : Nat) (l1 l2 : Program) : ∀ pq e,
    ngGo n pq e (l1 ++ l2) = ngGo n (ngGo n pq e l1).1 (ngGo n pq e l1).2 l2 := by
  induction l1 with
  | nil => intro pq e; rfl
  | cons i l ih => intro pq e; exact ih _ _

theorem ngGo_fst (n : Nat) (l : Program) : ∀ pq e, ∃ ext : Program,
    (ngGo n pq e l).1 = pq ++ ext ∧ ext.length = l.length := by
  induction l with
  | nil => intro pq e; exact ⟨[], by simp [ngGo], rfl⟩
  | cons i l ih =>
    intro pq e
    obtain ⟨ext, h1, h2⟩ := ih (pq ++ [(ngStep n pq e i).1]) (ngStep n pq e i).2
    exact ⟨(ngStep n pq e i).1 :: ext, by simp [ngGo, h1], by simp [h2]⟩

theorem ngRewrite_length (n : Nat) (p : Program) : (ngRewrite n p).length = p.length := by
  obtain ⟨ext, h1, h2⟩ := ngGo_fst n p [] false
  simp [ngRewrite, h1, h2]

theorem ngRewrite_take (n : Nat) (p : Program) (t : Nat) (ht : t ≤ p.length) :
    (ngRewrite n p).take t = (ngGo n [] false (p.take t)).1 := by
  obtain ⟨ext, h1, h2⟩ := ngGo_fst n (p.take t) [] false
  obtain ⟨ext2, h3, _⟩ := ngGo_fst n (p.drop t) (ngGo n [] false (p.take t)).1
    (ngGo n [] false (p.take t)).2
  have e : ngGo n [] false p = ngGo n [] false (p.take t ++ p.drop t) := by
    rw [List.take_append_drop]
  unfold ngRewrite
  rw [e, ngGo_append, h3]
  apply List.take_left'
  rw [h1]; simp [h2]; omega

/-! ### Accessed registers -/

theorem accd_snoc {n : Nat} {pq : Program} {j : Instr} {r : Nat} :
    accd n (pq ++ [j]) r ↔ accd n pq r ∨ r ∈ j.regs := by
  unfold accd
  constructor
  · rintro (h | ⟨i, hi, hr⟩)
    · exact Or.inl (Or.inl h)
    · rcases List.mem_append.mp hi with hi | hi
      · exact Or.inl (Or.inr ⟨i, hi, hr⟩)
      · rw [List.mem_singleton.mp hi] at hr; exact Or.inr hr
  · rintro ((h | ⟨i, hi, hr⟩) | h)
    · exact Or.inl h
    · exact Or.inr ⟨i, List.mem_append_left _ hi, hr⟩
    · exact Or.inr ⟨j, by simp, h⟩

theorem accd_append {n : Nat} {pq : Program} (l : Program) {r : Nat} (h : accd n pq r) :
    accd n (pq ++ l) r := by
  rcases h with h | ⟨i, hi, hr⟩
  · exact Or.inl h
  · exact Or.inr ⟨i, List.mem_append_left _ hi, hr⟩

theorem accd_ngGo {n : Nat} {pq : Program} {e : Bool} (l : Program) {r : Nat} (h : accd n pq r) :
    accd n (ngGo n pq e l).1 r := by
  obtain ⟨ext, h1, _⟩ := ngGo_fst n l pq e
  rw [h1]; exact accd_append _ h

theorem run_snoc (pq : Program) (j : Instr) (R : State Int) :
    run compare (pq ++ [j]) R = step compare (run compare pq R) j := by
  rw [run_append]; rfl

/-! ### Simulation invariant -/

/-- (I1) accessed registers agree, (I2) pristine registers hold their garbage in `p`'s run and
  `T = n` in the relaxed run of the rewrite, (I3) flags. -/
def InvS (n : Nat) (A : Nat → Prop) (e : Bool) (s R Rq : State Int) : Prop :=
  (∀ r, A r → R.regs r = Rq.regs r) ∧
  (∀ r, ¬ A r → R.regs r = s.regs r ∧ Rq.regs r = (n : Int)) ∧
  (e = false → R.flag = Rq.flag) ∧ (e = true → R.flag = .eq)

/-- Source register of an instruction (for an emitted `mov d e'`: `e'`). -/
def srcOf : Instr → Nat
  | .mov _ e' => e'
  | .cmp _ b => b
  | .cmov _ _ e' => e'

/-- Garbage condition for one emitted instruction `j`: a register of `j` that becomes accessed
  holds (in `s`) the relaxed value of the source of `j`. -/
def newC (A : Nat → Prop) (Rq : State Int) (j : Instr) (s : State Int) : Prop :=
  ∀ r ∈ j.regs, ¬ A r → s.regs r = Rq.regs (srcOf j)

macro "ng_fin" : tactic => `(tactic| (
  refine ⟨fun r hr => ?_, fun r hr => ?_, fun he => ?_, fun he => ?_⟩ <;>
  simp only [InvS, newC, accd_snoc, Instr.regs, srcOf, List.mem_cons, List.not_mem_nil, or_false,
    not_or, step, upd, forall_eq_or_imp, forall_eq, false_implies, implies_true, reduceCtorEq,
    Bool.false_eq_true] at * <;>
  (try rcases hr with hr | rfl | rfl) <;> (repeat' split) <;> (try simp only [upd] at *) <;> (repeat' split) <;> simp_all [Int.compare_eq_eq]))

theorem step_inv {n : Nat} (hn : 0 < n) {pq : Program} {e : Bool} {s R Rq : State Int} (i : Instr)
    (hI : InvS n (accd n pq) e s R Rq) (hC : newC (accd n pq) Rq (ngStep n pq e i).1 s) :
    InvS n (accd n (pq ++ [(ngStep n pq e i).1])) (ngStep n pq e i).2 s
      (step compare R i) (step compare Rq (ngStep n pq e i).1) := by
  obtain ⟨I1, I2, I3, I4⟩ := hI
  have h0 : accd n pq 0 := Or.inl hn
  cases i with
  | cmp a b =>
    by_cases hab : a = b
    · subst hab
      by_cases ha : accd n pq a
      · have E : ngStep n pq e (.cmp a a) = (.cmp a a, false) := by simp [ngStep, ha]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmp a a) = (.mov 0 0, true) := by simp [ngStep, ha]
        rw [E] at hC ⊢; ng_fin
    · by_cases ha : accd n pq a <;> by_cases hb : accd n pq b
      · have E : ngStep n pq e (.cmp a b) = (.cmp a b, false) := by simp [ngStep, hab, ha, hb]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmp a b) = (.mov b a, true) := by simp [ngStep, hab, ha, hb]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmp a b) = (.mov a b, true) := by simp [ngStep, hab, ha, hb]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmp a b) = (.mov a b, true) := by simp [ngStep, hab, ha, hb]
        rw [E] at hC ⊢; ng_fin
  | mov d src =>
    by_cases hds : d = src
    · subst hds
      have E : ngStep n pq e (.mov d d) = (.mov 0 0, e) := by simp [ngStep]
      rw [E] at hC ⊢; ng_fin
    · by_cases hd : accd n pq d <;> by_cases hs : accd n pq src
      · have E : ngStep n pq e (.mov d src) = (.mov d src, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.mov d src) = (.mov src d, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.mov d src) = (.mov d src, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.mov d src) = (.mov d src, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin
  | cmov c d src =>
    by_cases hds : d = src
    · subst hds
      have E : ngStep n pq e (.cmov c d d) = (.mov 0 0, e) := by simp [ngStep]
      rw [E] at hC ⊢; ng_fin
    · by_cases hd : accd n pq d <;> by_cases hs : accd n pq src
      · cases e
        · have E : ngStep n pq false (.cmov c d src) = (.cmov c d src, false) := by
            simp [ngStep, hds, hd, hs]
          rw [E] at hC ⊢; ng_fin
        · by_cases hc : c.eval .eq = true
          · have E : ngStep n pq true (.cmov c d src) = (.mov d src, true) := by
              simp [ngStep, hds, hd, hs, hc]
            rw [E] at hC ⊢; ng_fin
          · have E : ngStep n pq true (.cmov c d src) = (.mov 0 0, true) := by
              simp [ngStep, hds, hd, hs, hc]
            rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmov c d src) = (.mov src d, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmov c d src) = (.mov d src, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin
      · have E : ngStep n pq e (.cmov c d src) = (.mov d src, e) := by simp [ngStep, hds, hd, hs]
        rw [E] at hC ⊢; ng_fin

/-! ### Simulation along the fold -/

/-- Relaxed run (`T = n`) of an emitted prefix. -/
abbrev Rs (n : Nat) (x : Nat → Int) (pq : Program) : State Int := run compare pq (relaxInit n x n)

/-- The garbage conditions along the rest of the fold. -/
def GoodGo (n : Nat) (x : Nat → Int) (s : State Int) : Program → Bool → Program → Prop
  | _, _, [] => True
  | pq, e, i :: rest => newC (accd n pq) (Rs n x pq) (ngStep n pq e i).1 s ∧
      GoodGo n x s (pq ++ [(ngStep n pq e i).1]) (ngStep n pq e i).2 rest

theorem sim {n : Nat} (hn : 0 < n) (x : Nat → Int) (s : State Int) (rest : Program) :
    ∀ pp pq e, InvS n (accd n pq) e s (run compare pp s) (Rs n x pq) → GoodGo n x s pq e rest →
      InvS n (accd n (ngGo n pq e rest).1) (ngGo n pq e rest).2 s (run compare (pp ++ rest) s)
        (Rs n x (ngGo n pq e rest).1) := by
  induction rest with
  | nil => intro pp pq e h _; simpa [ngGo] using h
  | cons i rest ih =>
    intro pp pq e h hg
    have h2 := step_inv hn i h hg.1
    rw [← run_snoc, ← run_snoc] at h2
    have h3 := ih (pp ++ [i]) _ _ h2 hg.2
    have e1 : pp ++ i :: rest = pp ++ [i] ++ rest := by simp
    rw [e1]
    exact h3

theorem goodGo_append_left {n : Nat} {x : Nat → Int} {s : State Int} (l1 l2 : Program) :
    ∀ pq e, GoodGo n x s pq e (l1 ++ l2) → GoodGo n x s pq e l1 := by
  induction l1 with
  | nil => intros; trivial
  | cons i l ih => intro pq e h; exact ⟨h.1, ih _ _ h.2⟩

/-! ### Choice of the garbage -/

def updG (n : Nat) (x : Nat → Int) (pq : Program) (j : Instr) (g : Nat → Int) : Nat → Int :=
  fun r => if r ∈ j.regs ∧ ¬ accd n pq r then (Rs n x pq).regs (srcOf j) else g r

def buildG (n : Nat) (x : Nat → Int) : Program → Bool → Program → (Nat → Int) → Nat → Int
  | _, _, [], g => g
  | pq, e, i :: rest, g => buildG n x (pq ++ [(ngStep n pq e i).1]) (ngStep n pq e i).2 rest
      (updG n x pq (ngStep n pq e i).1 g)

theorem buildG_acc (n : Nat) (x : Nat → Int) (rest : Program) :
    ∀ pq e g r, accd n pq r → buildG n x pq e rest g r = g r := by
  induction rest with
  | nil => intros; rfl
  | cons i rest ih =>
    intro pq e g r hr
    show buildG n x _ _ rest _ r = g r
    rw [ih _ _ _ r (accd_append _ hr)]
    simp [updG, hr]

theorem buildG_range (n : Nat) (x : Nat → Int) (P : Int → Prop)
    (hR : ∀ pq r, P ((Rs n x pq).regs r)) (rest : Program) :
    ∀ pq e g, (∀ r, P (g r)) → ∀ r, P (buildG n x pq e rest g r) := by
  induction rest with
  | nil => intro pq e g hg r; exact hg r
  | cons i rest ih =>
    intro pq e g hg r
    apply ih
    intro r'
    simp only [updG]
    split
    · exact hR _ _
    · exact hg r'

theorem good_build (n : Nat) (x : Nat → Int) (s : State Int) (rest : Program) : ∀ pq e g,
    (∀ r, ¬ accd n pq r → s.regs r = buildG n x pq e rest g r) → GoodGo n x s pq e rest := by
  induction rest with
  | nil => intros; trivial
  | cons i rest ih =>
    intro pq e g hs
    refine ⟨fun r hr hna => ?_, ih _ _ (updG n x pq (ngStep n pq e i).1 g) (fun r hr => ?_)⟩
    · rw [hs r hna]
      show buildG n x _ _ rest _ r = _
      rw [buildG_acc n x rest _ _ _ r (accd_snoc.mpr (Or.inr hr))]
      simp [updG, hr, hna]
    · exact hs r (fun h => hr (accd_append _ h))

theorem good_perturb (n : Nat) (x : Nat → Int) (s s' : State Int) (rest : Program) : ∀ pq e,
    GoodGo n x s pq e rest → (∀ r, accd n (ngGo n pq e rest).1 r → s'.regs r = s.regs r) →
    GoodGo n x s' pq e rest := by
  induction rest with
  | nil => intros; trivial
  | cons i rest ih =>
    intro pq e hg hs
    refine ⟨fun r hr hna => ?_, ih _ _ hg.2 hs⟩
    rw [hs r (accd_ngGo (e := (ngStep n pq e i).2) rest (accd_snoc.mpr (Or.inr hr)))]
    exact hg.1 r hr hna

theorem run_range (P : Int → Prop) (pq : Program) :
    ∀ R : State Int, (∀ r, P (R.regs r)) → ∀ r, P ((run compare pq R).regs r) := by
  induction pq with
  | nil => intro R h; exact h
  | cons i pq ih =>
    intro R h
    apply ih
    intro r
    cases i with
    | mov d s' => simp only [step, upd]; split <;> exact h _
    | cmp a b => exact h r
    | cmov c d s' =>
      simp only [step]
      split
      · simp only [upd]; split <;> exact h _
      · exact h r

/-! ### NG-normality -/

set_option linter.unusedSimpArgs false in
theorem ngStep_ok {n : Nat} (hn : 0 < n) (pq : Program) (e : Bool) (i : Instr) :
    ngOK n pq (ngStep n pq e i).1 := by
  have h0 : accd n pq 0 := Or.inl hn
  unfold ngOK
  cases i with
  | cmp a b =>
    simp only [ngStep]
    by_cases hab : a = b <;> by_cases ha : accd n pq a <;> by_cases hb : accd n pq b <;>
      (simp [hab, ha, hb, h0, Instr.reads]) <;> exact ⟨_, _, ⟨rfl, rfl⟩, hab, ha, hb⟩
  | mov d src =>
    simp only [ngStep]
    by_cases hab : d = src <;> by_cases ha : accd n pq d <;> by_cases hb : accd n pq src <;>
      (simp [hab, ha, hb, h0, Instr.reads]) <;> exact ⟨_, _, ⟨rfl, rfl⟩, hab, ha, hb⟩
  | cmov c d src =>
    simp only [ngStep]
    by_cases hab : d = src <;> by_cases ha : accd n pq d <;> by_cases hb : accd n pq src <;>
      cases e <;> cases hc : c.eval .eq <;> (simp [hab, ha, hb, h0, hc, Instr.reads]) <;> exact ⟨_, _, ⟨rfl, rfl⟩, hab, ha, hb⟩

theorem ngGo_ok {n : Nat} (hn : 0 < n) (rest : Program) : ∀ pq e,
    (∀ t (h : t < pq.length), ngOK n (pq.take t) pq[t]) →
    ∀ t (h : t < (ngGo n pq e rest).1.length), ngOK n ((ngGo n pq e rest).1.take t)
      (ngGo n pq e rest).1[t] := by
  induction rest with
  | nil => intro pq e h; exact h
  | cons i rest ih =>
    intro pq e h
    apply ih
    intro t ht
    simp only [List.length_append, List.length_singleton] at ht
    by_cases ht' : t < pq.length
    · rw [List.take_append_of_le_length (by omega), List.getElem_append_left ht']
      exact h t ht'
    · have et : t = pq.length := by omega
      subst et
      rw [List.take_left' rfl]
      simp only [List.getElem_append_right (Nat.le_refl _), Nat.sub_self]
      exact ngStep_ok hn pq e i

/-! ### Strict correctness on small states -/

theorem xsnap_small {n : Nat} (hn : n < 2 ^ 31 - 1) {p : Program} {o : Snap} (h : XSnap n p o)
    (v : Nat → Int) (hv : ∀ r, 0 ≤ v r ∧ v r ≤ n) : SortsOK n v (snapOut p o ⟨v, .eq⟩) := by
  let X : XState :=
    { regs := fun r => BitVec.ofInt 32 (v r), cf := false, zf := true, sf := false, of := false }
  have hX : ∀ r, (X.regs r).toInt = v r := fun r =>
    toInt_ofInt_small _ (hv r).1 (by have := (hv r).2; omega)
  have habs : X.abs = ⟨v, .eq⟩ := by
    unfold XState.abs
    rw [funext hX]
    rfl
  have h1 := h X
  rw [xsnapOut_abs, habs, funext hX] at h1
  exact h1

theorem sortsOK_out_eq {n : Nat} {x y y' : Nat → Int} (h : SortsOK n x y) (h' : SortsOK n x y') :
    ∀ j < n, y j = y' j := by
  intro j hj
  unfold SortsOK at h h'
  exact List.map_inj_left.mp (h.trans h'.symm) j (List.mem_range.mpr hj)

/-! ### Main theorem -/

theorem ng_rewrite {n : Nat} (hn2 : 2 ≤ n) (hn : n < 2 ^ 31 - 1) {p : Program} {o : Snap}
    (h : XSnap n p o) :
    ∃ q : Program, q.length = p.length ∧ NGNormal n q ∧
      ∀ x : Nat → Int, (∀ i < n, 0 ≤ x i ∧ x i < n) →
        SortsOK n x (snapOut q o (relaxInit n x n)) := by
  have hn0 : 0 < n := by omega
  refine ⟨ngRewrite n p, ngRewrite_length n p,
    ngGo_ok hn0 p [] false (fun t h => absurd h (by simp)), ?_⟩
  intro x hx
  have hR : ∀ pq r, 0 ≤ (Rs n x pq).regs r ∧ (Rs n x pq).regs r ≤ n := fun pq =>
    run_range (fun v => 0 ≤ v ∧ v ≤ n) pq _ (fun r => by
      simp only [relaxInit]
      split
      · have := hx r ‹_›; omega
      · omega)
  let g := buildG n x [] false p (fun _ => n)
  have hg : ∀ r, 0 ≤ g r ∧ g r ≤ n :=
    buildG_range n x (fun v => 0 ≤ v ∧ v ≤ n) hR p [] false _ (fun _ => by omega)
  let s : State Int := ⟨fun r => if r < n then x r else g r, .eq⟩
  have hsx : ∀ i < n, s.regs i = x i := fun i hi => by simp [s, hi]
  have hsr : ∀ r, 0 ≤ s.regs r ∧ s.regs r ≤ n := fun r => by
    simp only [s]
    split
    · have := hx r ‹_›; omega
    · exact hg r
  have hgood : GoodGo n x s [] false p := good_build n x s p [] false (fun _ => n) (fun r hr => by
    have : ¬ r < n := fun h' => hr (Or.inl h')
    simp [s, this, g])
  have hinit : ∀ s' : State Int, (∀ i < n, s'.regs i = x i) → s'.flag = .eq →
      InvS n (accd n []) false s' (run compare [] s') (Rs n x []) := by
    intro s' h1 h2
    refine ⟨fun r hr => ?_, fun r hr => ?_, fun _ => ?_, fun he => absurd he (by simp)⟩
    · have hr' : r < n := by
        rcases hr with hr | ⟨i, hi, _⟩
        · exact hr
        · simp at hi
      simp [relaxInit, hr', h1 r hr']
    · have hr' : ¬ r < n := fun h' => hr (Or.inl h')
      simp [relaxInit, hr']
    · simp [relaxInit, h2]
  have hinv : ∀ s' : State Int, (∀ i < n, s'.regs i = x i) → s'.flag = .eq → ∀ t ≤ p.length,
      GoodGo n x s' [] false (p.take t) →
      InvS n (accd n ((ngRewrite n p).take t)) (ngGo n [] false (p.take t)).2 s'
        (run compare (p.take t) s') (Rs n x ((ngRewrite n p).take t)) := by
    intro s' h1 h2 t ht hg'
    rw [ngRewrite_take n p t ht]
    have := sim hn0 x s' (p.take t) [] [] false (hinit s' h1 h2) hg'
    simpa using this
  have hgt : ∀ t, GoodGo n x s [] false (p.take t) := fun t => by
    have : GoodGo n x s [] false (p.take t ++ p.drop t) := by rw [List.take_append_drop]; exact hgood
    exact goodGo_append_left _ _ _ _ this
  have hp : SortsOK n x (snapOut p o s) :=
    (sortsOK_congr hsx (fun _ _ => rfl)).mp (xsnap_small hn h s.regs hsr)
  refine (sortsOK_congr (fun _ _ => rfl) (fun j hj => ?_)).mp hp
  have hlen := ngRewrite_length n p
  have ht : min (o j).2 p.length ≤ p.length := Nat.min_le_right _ _
  have e1 : ∀ s' : State Int, snapOut p o s' j =
      (run compare (p.take (min (o j).2 p.length)) s').regs (o j).1 := by
    intro s'; simp only [snapOut, take_min]
  have e2 : snapOut (ngRewrite n p) o (relaxInit n x n) j =
      (Rs n x ((ngRewrite n p).take (min (o j).2 p.length))).regs (o j).1 := by
    simp only [snapOut, Rs]; rw [← hlen, take_min]
  rw [e1, e2]
  have I := hinv s hsx rfl _ ht (hgt _)
  by_cases hacc : accd n ((ngRewrite n p).take (min (o j).2 p.length)) (o j).1
  · exact I.1 _ hacc
  · exfalso
    have hr0 : ¬ (o j).1 < n := fun h' => hacc (Or.inl h')
    let s' : State Int :=
      ⟨fun r => if r = (o j).1 then (if s.regs (o j).1 = 0 then 1 else 0) else s.regs r, .eq⟩
    have hs'x : ∀ i < n, s'.regs i = x i := fun i hi => by
      have : i ≠ (o j).1 := fun e => hr0 (e ▸ hi)
      simp only [s', if_neg this]; exact hsx i hi
    have hs'r : ∀ r, 0 ≤ s'.regs r ∧ s'.regs r ≤ n := fun r => by
      simp only [s']
      split
      · split <;> omega
      · exact hsr r
    have hg' : GoodGo n x s' [] false (p.take (min (o j).2 p.length)) := by
      apply good_perturb n x s s' _ [] false (hgt _)
      intro r hr
      rw [← ngRewrite_take n p _ ht] at hr
      have : r ≠ (o j).1 := fun e => hacc (e ▸ hr)
      simp only [s', if_neg this]
    have I' := hinv s' hs'x rfl _ ht hg'
    have hp' : SortsOK n x (snapOut p o s') :=
      (sortsOK_congr hs'x (fun _ _ => rfl)).mp (xsnap_small hn h s'.regs hs'r)
    have heq := sortsOK_out_eq hp hp' j hj
    rw [e1, e1, (I.2.1 _ hacc).1, (I'.2.1 _ hacc).1] at heq
    simp only [s', ↓reduceIte] at heq
    split at heq <;> omega

end LeanReflect.NGR
