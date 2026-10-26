import SortProof.Snap
import SortProof.SortFacts
/-
  Lemma L5 (theory lemmas.md / appendix_proofs.tex): memory model MM → snapshot model RS.
  An MM program is a `Program` in which registers `< n` are the memory cells, touched only by
  loads `mov r, i` and stores `mov i, r` (MM-1). MM semantics = RF semantics (cells read at the end).
  * `l5`             : n ≥ 2, MM program q relaxed-correct ⇒ an RS program p, |p| + 2n ≤ |q|, same iset,
                       relaxed-correct with snapshots.
  * `mm_lower_bound` : RS search hypothesis at length K ⇒ no MM program of length ≤ K + 2n is x86-correct.
  Translation: per-segment registers G i s (segment s of cell i = time between stores);
  the last load of a segment renames its target to G i s; the last store gives the snapshot.
-/
namespace SortProof

/-- MM-1 operand rules for one instruction. -/
def MMInstr (n : Nat) : Instr → Prop
  | .mov d s => ¬ (d < n ∧ s < n)
  | .cmp a b => n ≤ a ∧ n ≤ b
  | .cmov _ d s => n ≤ d ∧ n ≤ s

/-- MM program (theory's statement: `∀ i ∈ q, match i with ...`, here via `MMInstr`). -/
def MMProg (n : Nat) (q : Program) : Prop := ∀ i ∈ q, MMInstr n i

/-! ### Classification of instructions w.r.t. a cell -/

def isLoad (n i : Nat) : Instr → Bool
  | .mov d s => s == i && i < n && n ≤ d
  | _ => false

def isStore (n i : Nat) : Instr → Bool
  | .mov d s => d == i && i < n && n ≤ s
  | _ => false

/-- Kind of the next instruction that touches cell `i`: `some true` = load, `some false` = store. -/
def nextI (n i : Nat) : Program → Option Bool
  | [] => none
  | ins :: rest => if isLoad n i ins then some true else if isStore n i ins then some false
      else nextI n i rest

def loadAhead (n i : Nat) (rest : Program) : Bool := nextI n i rest == some true

def storeAhead (n i : Nat) (rest : Program) : Bool := rest.any (isStore n i)

/-! ### The translation -/

structure TS where
  nu : Nat → Nat
  seg : Nat → Nat
  G : Nat → Nat → Nat
  fresh : Nat
  out : Program
  snap : Nat → Nat × Nat

def trStep (n : Nat) (t : TS) (ins : Instr) (rest : Program) : TS :=
  match ins with
  | .mov d s =>
    if s < n then
      -- load of cell s into d
      if loadAhead n s rest then { t with out := t.out ++ [.mov (t.nu d) (t.G s (t.seg s))] }
      else { t with nu := upd t.nu d (t.G s (t.seg s)) }
    else if d < n then
      -- store of s into cell d, opens segment seg d + 1
      let k := t.seg d + 1
      let t1 : TS :=
        if loadAhead n d rest then
          { t with seg := upd t.seg d k,
                   G := fun i j => if i = d ∧ j = k then t.fresh else t.G i j,
                   fresh := t.fresh + 1,
                   out := t.out ++ [.mov t.fresh (t.nu s)] }
        else { t with seg := upd t.seg d k }
      if storeAhead n d rest then t1 else { t1 with snap := upd t1.snap d (t.nu s, t1.out.length) }
    else { t with out := t.out ++ [.mov (t.nu d) (t.nu s)] }
  | .cmp a b => { t with out := t.out ++ [.cmp (t.nu a) (t.nu b)] }
  | .cmov c d s => { t with out := t.out ++ [.cmov c (t.nu d) (t.nu s)] }

def tr (n : Nat) : TS → Program → TS
  | t, [] => t
  | t, ins :: rest => tr n (trStep n t ins rest) rest

def maxReg : Program → Nat
  | [] => 0
  | i :: p => max (i.regs.foldr max 0) (maxReg p)

def t0 (B : Nat) : TS :=
  { nu := id, seg := fun _ => 0, G := fun i _ => i, fresh := B, out := [], snap := fun j => (j, 0) }

def l5prog (n : Nat) (q : Program) : TS := tr n (t0 (maxReg q + n + 1)) q

theorem le_foldr_max : ∀ (l : List Nat) (r : Nat), r ∈ l → r ≤ l.foldr max 0
  | [], _, h => by simp at h
  | a :: l, r, h => by
    simp only [List.foldr_cons]
    rcases List.mem_cons.mp h with rfl | h'
    · omega
    · have := le_foldr_max l r h'; omega

theorem regs_lt_maxReg {q : Program} : ∀ i ∈ q, ∀ r ∈ i.regs, r ≤ maxReg q := by
  induction q with
  | nil => intro i hi; simp at hi
  | cons j q ih =>
    intro i hi r hr
    simp only [maxReg]
    rcases List.mem_cons.mp hi with rfl | hi'
    · have := le_foldr_max _ r hr; omega
    · have := ih i hi' r hr; omega


/-! ### Look-ahead lemmas -/

theorem nextI_cons_load {n i d s : Nat} (hs : s = i) (hi : i < n) (hd : n ≤ d) (rest : Program) :
    nextI n i (.mov d s :: rest) = some true := by
  subst hs; simp [nextI, isLoad, hi, hd]

theorem nextI_cons_store {n i d s : Nat} (hd : d = i) (hi : i < n) (hs : n ≤ s) (rest : Program) :
    nextI n i (.mov d s :: rest) = some false := by
  subst hd
  have : ¬ (s = d) := by omega
  simp [nextI, isLoad, isStore, hi, hs, this]

theorem nextI_cons_other {n i : Nat} {ins : Instr} (h1 : isLoad n i ins = false)
    (h2 : isStore n i ins = false) (rest : Program) : nextI n i (ins :: rest) = nextI n i rest := by
  simp [nextI, h1, h2]

theorem storeAhead_cons (n i : Nat) (ins : Instr) (rest : Program) :
    storeAhead n i (ins :: rest) = (isStore n i ins || storeAhead n i rest) := by
  simp [storeAhead]

/-! ### Simulation invariant -/

structure Inv (n B : Nat) (t : TS) (rest : Program) (qs init : State Int) : Prop where
  i1 : ∀ r, n ≤ r → r < B → (run compare t.out init).regs (t.nu r) = qs.regs r
  i2 : ∀ i < n, loadAhead n i rest = true →
    (run compare t.out init).regs (t.G i (t.seg i)) = qs.regs i
  i3 : (run compare t.out init).flag = qs.flag
  i4 : ∀ i < n, storeAhead n i rest = false → (t.snap i).2 ≤ t.out.length ∧
    (run compare (t.out.take (t.snap i).2) init).regs (t.snap i).1 = qs.regs i
  n1 : ∀ r r', n ≤ r → r < B → n ≤ r' → r' < B → t.nu r = t.nu r' → r = r'
  n2 : ∀ r, n ≤ r → r < B → ∀ i < n, loadAhead n i rest = true → t.nu r ≠ t.G i (t.seg i)
  n3 : ∀ i j, i < n → j < n → i ≠ j → loadAhead n i rest = true → loadAhead n j rest = true →
    t.G i (t.seg i) ≠ t.G j (t.seg j)
  n4 : ∀ r, n ≤ r → r < B → t.nu r < t.fresh
  n5 : ∀ i < n, loadAhead n i rest = true → t.G i (t.seg i) < t.fresh

theorem run_snoc (out : Program) (i : Instr) (init : State Int) :
    run compare (out ++ [i]) init = step compare (run compare out init) i := by
  rw [run_append]; rfl

/-- `i4` survives appending to `out` when the snapshot and the cell value do not change. -/
theorem i4_keep {t : TS} {e : Program} {snap' : Nat × Nat} {init : State Int} {v : Int}
    (hs : snap' = t.snap j)
    (h : (t.snap j).2 ≤ t.out.length ∧
      (run compare (t.out.take (t.snap j).2) init).regs (t.snap j).1 = v) :
    snap'.2 ≤ (t.out ++ e).length ∧
      (run compare ((t.out ++ e).take snap'.2) init).regs snap'.1 = v := by
  subst hs
  refine ⟨by simp; omega, ?_⟩
  rw [List.take_append_of_le_length h.1]; exact h.2


/-- Instructions that touch no cell (all operands `≥ n`). -/
theorem noCell_flags {n : Nat} {ins : Instr} (h : ∀ r ∈ ins.regs, n ≤ r) (i : Nat) (hi : i < n) :
    isLoad n i ins = false ∧ isStore n i ins = false := by
  cases ins with
  | mov d s =>
    have := h d (by simp [Instr.regs]); have := h s (by simp [Instr.regs])
    constructor <;> simp [isLoad, isStore] <;> intros <;> omega
  | cmp a b => simp [isLoad, isStore]
  | cmov c d s => simp [isLoad, isStore]

/-- Step for a register instruction `mov d s` / `cmp a b` / `cmov c d s` (operands `≥ n`). -/
theorem inv_step_reg {n B : Nat} {t : TS} {ins : Instr} {rest : Program} {qs init : State Int}
    (hge : ∀ r ∈ ins.regs, n ≤ r) (hlt : ∀ r ∈ ins.regs, r < B)
    (hnot : ¬ ∃ d s, ins = .mov d s ∧ (s < n ∨ d < n))
    (h : Inv n B t (ins :: rest) qs init) :
    Inv n B (trStep n t ins rest) rest (step compare qs ins) init := by
  have hla : ∀ i < n, loadAhead n i (ins :: rest) = loadAhead n i rest := fun i hi => by
    obtain ⟨h1, h2⟩ := noCell_flags hge i hi
    simp [loadAhead, nextI_cons_other h1 h2]
  have hsa : ∀ i < n, storeAhead n i (ins :: rest) = storeAhead n i rest := fun i hi => by
    obtain ⟨_, h2⟩ := noCell_flags hge i hi
    simp [storeAhead_cons, h2]
  -- the emitted instruction and the shape of trStep
  obtain ⟨e, he, hstep⟩ : ∃ e : Instr, trStep n t ins rest = { t with out := t.out ++ [e] } ∧
      e = ins.rename t.nu := by
    cases ins with
    | mov d s =>
      have hs : ¬ s < n := fun hs => hnot ⟨d, s, rfl, Or.inl hs⟩
      have hd : ¬ d < n := fun hd => hnot ⟨d, s, rfl, Or.inr hd⟩
      exact ⟨.mov (t.nu d) (t.nu s), by simp [trStep, hs, hd], rfl⟩
    | cmp a b => exact ⟨_, rfl, rfl⟩
    | cmov c d s => exact ⟨_, rfl, rfl⟩
  rw [he]
  have hrun : run compare (t.out ++ [e]) init = step compare (run compare t.out init) e := run_snoc _ _ _
  obtain ⟨i1, i2, i3, i4, n1, n2, n3, n4, n5⟩ := h
  -- Sim relation on the registers < B that matter
  have hsim : ∀ (r : Nat), n ≤ r → r < B →
      (step compare (run compare t.out init) e).regs (t.nu r) = (step compare qs ins).regs r := by
    intro r hr1 hr2
    subst hstep
    cases ins with
    | mov d s =>
      have hd1 := hge d (by simp [Instr.regs]); have hs1 := hge s (by simp [Instr.regs])
      have hd2 := hlt d (by simp [Instr.regs]); have hs2 := hlt s (by simp [Instr.regs])
      simp only [Instr.rename, step, upd]
      by_cases e1 : r = d
      · subst e1; simp [i1 _ hs1 hs2]
      · have : t.nu r ≠ t.nu d := fun h' => e1 (n1 r d hr1 hr2 hd1 hd2 h')
        simp [e1, this, i1 r hr1 hr2]
    | cmp a b => exact i1 r hr1 hr2
    | cmov c d s =>
      have hd1 := hge d (by simp [Instr.regs]); have hs1 := hge s (by simp [Instr.regs])
      have hd2 := hlt d (by simp [Instr.regs]); have hs2 := hlt s (by simp [Instr.regs])
      simp only [Instr.rename, step, i3]
      split
      · simp only [upd]
        by_cases e1 : r = d
        · subst e1; simp [i1 _ hs1 hs2]
        · have : t.nu r ≠ t.nu d := fun h' => e1 (n1 r d hr1 hr2 hd1 hd2 h')
          simp [e1, this, i1 r hr1 hr2]
      · exact i1 r hr1 hr2
  -- cells and active G names are unchanged
  have hcell : ∀ i < n, (step compare qs ins).regs i = qs.regs i := by
    intro i hi
    cases ins with
    | mov d s =>
      have := hge d (by simp [Instr.regs]); simp [step, upd]; intro; omega
    | cmp a b => rfl
    | cmov c d s =>
      have := hge d (by simp [Instr.regs]); simp only [step]; split
      · simp [upd]; intro; omega
      · rfl
  have hG : ∀ i < n, loadAhead n i rest = true →
      (step compare (run compare t.out init) e).regs (t.G i (t.seg i)) =
        (run compare t.out init).regs (t.G i (t.seg i)) := by
    intro i hi hl
    subst hstep
    cases ins with
    | mov d s =>
      have hd1 := hge d (by simp [Instr.regs]); have hd2 := hlt d (by simp [Instr.regs])
      have := n2 d hd1 hd2 i hi (by rw [hla i hi]; exact hl)
      simp [Instr.rename, step, upd, Ne.symm this]
    | cmp a b => rfl
    | cmov c d s =>
      have hd1 := hge d (by simp [Instr.regs]); have hd2 := hlt d (by simp [Instr.regs])
      have := n2 d hd1 hd2 i hi (by rw [hla i hi]; exact hl)
      simp only [Instr.rename, step]; split
      · simp [upd, Ne.symm this]
      · rfl
  refine ⟨?_, ?_, ?_, ?_, n1, ?_, ?_, n4, ?_⟩
  · intro r hr1 hr2; rw [hrun]; exact hsim r hr1 hr2
  · intro i hi hl; rw [hrun, hG i hi hl, hcell i hi]; exact i2 i hi (by rw [hla i hi]; exact hl)
  · rw [hrun]; subst hstep
    cases ins with
    | mov d s => exact i3
    | cmp a b =>
      have ha1 := hge a (by simp [Instr.regs]); have hb1 := hge b (by simp [Instr.regs])
      have ha2 := hlt a (by simp [Instr.regs]); have hb2 := hlt b (by simp [Instr.regs])
      simp only [Instr.rename, step, i1 a ha1 ha2, i1 b hb1 hb2]
    | cmov c d s =>
      simp only [Instr.rename, step, i3]; split <;> (first | rfl | exact i3)
  · intro i hi hs
    rw [hcell i hi]
    exact i4_keep rfl (i4 i hi (by rw [hsa i hi]; exact hs))
  · intro r hr1 hr2 i hi hl; exact n2 r hr1 hr2 i hi (by rw [hla i hi]; exact hl)
  · intro i j hi hj hij hli hlj
    exact n3 i j hi hj hij (by rw [hla i hi]; exact hli) (by rw [hla j hj]; exact hlj)
  · intro i hi hl; exact n5 i hi (by rw [hla i hi]; exact hl)


theorem load_flags {n c d : Nat} (hc : c < n) (hd : n ≤ d) (i : Nat) :
    isStore n i (.mov d c) = false ∧ (i ≠ c → isLoad n i (.mov d c) = false) := by
  constructor
  · simp [isStore]; intros; omega
  · intro h; simp [isLoad]; intro h'; exact absurd h'.symm h

/-- Step for a load `mov d c` (cell `c < n`, register `d ≥ n`). -/
theorem inv_step_load {n B : Nat} {t : TS} {d c : Nat} {rest : Program} {qs init : State Int}
    (hc : c < n) (hd : n ≤ d) (hdB : d < B)
    (h : Inv n B t (.mov d c :: rest) qs init) :
    Inv n B (trStep n t (.mov d c) rest) rest (step compare qs (.mov d c)) init := by
  have hla_c : loadAhead n c (.mov d c :: rest) = true := by
    simp [loadAhead, nextI_cons_load rfl hc hd]
  have hla : ∀ i < n, i ≠ c → loadAhead n i (.mov d c :: rest) = loadAhead n i rest := by
    intro i hi hic
    obtain ⟨h1, h2⟩ := load_flags hc hd i
    simp [loadAhead, nextI_cons_other (h2 hic) h1]
  have hla' : ∀ i < n, loadAhead n i rest = true → loadAhead n i (.mov d c :: rest) = true := by
    intro i hi hl
    by_cases hic : i = c
    · subst hic; exact hla_c
    · rw [hla i hi hic]; exact hl
  have hsa : ∀ i < n, storeAhead n i (.mov d c :: rest) = storeAhead n i rest := fun i hi => by
    simp [storeAhead_cons, (load_flags hc hd i).1]
  have hcell : ∀ i < n, (step compare qs (.mov d c)).regs i = qs.regs i := by
    intro i hi; simp [step, upd]; intro; omega
  obtain ⟨i1, i2, i3, i4, n1, n2, n3, n4, n5⟩ := h
  have hval := i2 c hc hla_c
  by_cases hl : loadAhead n c rest = true
  · -- not the last load: copy
    have he : trStep n t (.mov d c) rest =
        { t with out := t.out ++ [.mov (t.nu d) (t.G c (t.seg c))] } := by
      simp [trStep, hc, hl]
    rw [he]
    have hrun := run_snoc t.out (.mov (t.nu d) (t.G c (t.seg c))) init
    refine ⟨?_, ?_, ?_, ?_, n1, ?_, ?_, n4, ?_⟩
    · intro r hr1 hr2
      rw [hrun]
      simp only [step, upd]
      by_cases e1 : r = d
      · subst e1; simp [hval]
      · have : t.nu r ≠ t.nu d := fun h' => e1 (n1 r d hr1 hr2 hd hdB h')
        simp [e1, this, i1 r hr1 hr2]
    · intro i hi hli
      rw [hrun, hcell i hi]
      have := n2 d hd hdB i hi (hla' i hi hli)
      simp [step, upd, Ne.symm this, i2 i hi (hla' i hi hli)]
    · rw [hrun]; exact i3
    · intro i hi hs
      rw [hcell i hi]
      exact i4_keep rfl (i4 i hi (by rw [hsa i hi]; exact hs))
    · intro r hr1 hr2 i hi hli; exact n2 r hr1 hr2 i hi (hla' i hi hli)
    · intro i j hi hj hij hli hlj; exact n3 i j hi hj hij (hla' i hi hli) (hla' j hj hlj)
    · intro i hi hli; exact n5 i hi (hla' i hi hli)
  · -- last load of the segment: rename d to G c (seg c)
    have hl' : loadAhead n c rest = false := by simpa using hl
    have he : trStep n t (.mov d c) rest = { t with nu := upd t.nu d (t.G c (t.seg c)) } := by
      simp [trStep, hc, hl']
    rw [he]
    have hnc : ∀ i < n, loadAhead n i rest = true → i ≠ c := by
      intro i _ hli hic; subst hic; rw [hl'] at hli; exact Bool.false_ne_true hli
    refine ⟨?_, ?_, i3, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · intro r hr1 hr2
      simp only [step, upd]
      by_cases e1 : r = d
      · subst e1; simp [hval]
      · simp [e1, i1 r hr1 hr2]
    · intro i hi hli
      show (run compare t.out init).regs (t.G i (t.seg i)) = _
      rw [hcell i hi]; exact i2 i hi (hla' i hi hli)
    · intro i hi hs
      rw [hcell i hi]
      exact i4 i hi (by rw [hsa i hi]; exact hs)
    · intro r r' hr1 hr2 hr1' hr2' he'
      simp only [upd] at he'
      by_cases e1 : r = d <;> by_cases e2 : r' = d
      · rw [e1, e2]
      · rw [if_pos e1, if_neg e2] at he'
        exact absurd he'.symm (n2 r' hr1' hr2' c hc hla_c)
      · rw [if_neg e1, if_pos e2] at he'
        exact absurd he' (n2 r hr1 hr2 c hc hla_c)
      · rw [if_neg e1, if_neg e2] at he'; exact n1 r r' hr1 hr2 hr1' hr2' he'
    · intro r hr1 hr2 i hi hli
      simp only [upd]
      by_cases e1 : r = d
      · rw [if_pos e1]
        exact n3 c i hc hi (Ne.symm (hnc i hi hli)) hla_c (hla' i hi hli)
      · rw [if_neg e1]; exact n2 r hr1 hr2 i hi (hla' i hi hli)
    · intro i j hi hj hij hli hlj; exact n3 i j hi hj hij (hla' i hi hli) (hla' j hj hlj)
    · intro r hr1 hr2
      simp only [upd]
      by_cases e1 : r = d
      · rw [if_pos e1]; exact n5 c hc hla_c
      · rw [if_neg e1]; exact n4 r hr1 hr2
    · intro i hi hli; exact n5 i hi (hla' i hi hli)


theorem store_flags {n d c : Nat} (hd : d < n) (hc : n ≤ c) (i : Nat) :
    isLoad n i (.mov d c) = false ∧ (i ≠ d → isStore n i (.mov d c) = false) := by
  constructor
  · simp [isLoad]; intros; omega
  · intro h; simp [isStore]; intro h'; exact absurd h'.symm h

/-- Snapshot part of the store step, shared by both sub-cases. -/
theorem store_snap {n : Nat} {t t1 : TS} {d c : Nat} {rest : Program} {qs init : State Int}
    {e : Program} (hd : d < n) (hc : n ≤ c)
    (hout : t1.out = t.out ++ e) (hsnap : t1.snap = t.snap)
    (hval : (run compare t1.out init).regs (t.nu c) = qs.regs c)
    (i4 : ∀ i < n, storeAhead n i (.mov d c :: rest) = false → (t.snap i).2 ≤ t.out.length ∧
      (run compare (t.out.take (t.snap i).2) init).regs (t.snap i).1 = qs.regs i) :
    let t2 := if storeAhead n d rest then t1 else { t1 with snap := upd t1.snap d (t.nu c, t1.out.length) }
    t2.out = t1.out ∧ t2.nu = t1.nu ∧ t2.seg = t1.seg ∧ t2.G = t1.G ∧ t2.fresh = t1.fresh ∧
    ∀ i < n, storeAhead n i rest = false → (t2.snap i).2 ≤ t2.out.length ∧
      (run compare (t2.out.take (t2.snap i).2) init).regs (t2.snap i).1 =
        (step compare qs (.mov d c)).regs i := by
  intro t2
  have hsa : ∀ i < n, i ≠ d → storeAhead n i (.mov d c :: rest) = storeAhead n i rest := by
    intro i hi hid; simp [storeAhead_cons, (store_flags hd hc i).2 hid]
  have hq : ∀ i, i ≠ d → (step compare qs (.mov d c)).regs i = qs.regs i := by
    intro i hid; simp [step, upd, hid]
  have hqd : (step compare qs (.mov d c)).regs d = qs.regs c := by simp [step, upd]
  have other : ∀ i < n, i ≠ d → storeAhead n i rest = false → (t1.snap i).2 ≤ t1.out.length ∧
      (run compare (t1.out.take (t1.snap i).2) init).regs (t1.snap i).1 =
        (step compare qs (.mov d c)).regs i := by
    intro i hi hid hs
    rw [hq i hid, hout, hsnap]
    exact i4_keep rfl (i4 i hi (by rw [hsa i hi hid]; exact hs))
  by_cases hS : storeAhead n d rest = true
  · have e2 : t2 = t1 := by simp [t2, hS]
    rw [e2]
    refine ⟨rfl, rfl, rfl, rfl, rfl, fun i hi hs => ?_⟩
    by_cases hid : i = d
    · subst hid; rw [hS] at hs; exact absurd hs (by decide)
    · exact other i hi hid hs
  · have hS' : storeAhead n d rest = false := by simpa using hS
    have e2 : t2 = { t1 with snap := upd t1.snap d (t.nu c, t1.out.length) } := by simp [t2, hS']
    rw [e2]
    refine ⟨rfl, rfl, rfl, rfl, rfl, fun i hi hs => ?_⟩
    by_cases hid : i = d
    · subst hid
      simp only [upd, if_true]
      refine ⟨Nat.le_refl _, ?_⟩
      rw [List.take_length, hqd]; exact hval
    · simp only [upd, if_neg hid]
      exact other i hi hid hs

/-- Step for a store `mov d c` (cell `d < n`, register `c ≥ n`). -/
theorem inv_step_store {n B : Nat} {t : TS} {d c : Nat} {rest : Program} {qs init : State Int}
    (hd : d < n) (hc : n ≤ c) (hcB : c < B)
    (h : Inv n B t (.mov d c :: rest) qs init) :
    Inv n B (trStep n t (.mov d c) rest) rest (step compare qs (.mov d c)) init := by
  have hcn : ¬ c < n := by omega
  have hla : ∀ i < n, i ≠ d → loadAhead n i (.mov d c :: rest) = loadAhead n i rest := by
    intro i hi hid
    obtain ⟨h1, h2⟩ := store_flags hd hc i
    simp [loadAhead, nextI_cons_other h1 (h2 hid)]
  have hq : ∀ i, i ≠ d → (step compare qs (.mov d c)).regs i = qs.regs i := by
    intro i hid; simp [step, upd, hid]
  have hqd : (step compare qs (.mov d c)).regs d = qs.regs c := by simp [step, upd]
  obtain ⟨i1, i2, i3, i4, n1, n2, n3, n4, n5⟩ := h
  let k := t.seg d + 1
  by_cases hl : loadAhead n d rest = true
  · let f := t.fresh
    let t1 : TS :=
      { t with
        seg := upd t.seg d k
        G := fun i j => if i = d ∧ j = k then f else t.G i j
        fresh := f + 1
        out := t.out ++ [.mov f (t.nu c)] }
    have he : trStep n t (.mov d c) rest =
        if storeAhead n d rest then t1 else { t1 with snap := upd t1.snap d (t.nu c, t1.out.length) } := by
      simp [trStep, hcn, hd, hl, t1, f, k]
    have hrun : run compare t1.out init =
        step compare (run compare t.out init) (.mov f (t.nu c)) := run_snoc _ _ _
    have hGd : t1.G d (t1.seg d) = f := by simp [t1, upd, k]
    have hGo : ∀ i, i ≠ d → t1.G i (t1.seg i) = t.G i (t.seg i) := by
      intro i hid; simp [t1, upd, hid]
    have hc_ne : t.nu c ≠ f := Nat.ne_of_lt (n4 c hc hcB)
    have hval : (run compare t1.out init).regs (t.nu c) = qs.regs c := by
      rw [hrun]; simp [step, upd, hc_ne, i1 c hc hcB]
    obtain ⟨o1, o2, o3, o4, o5, o6⟩ := store_snap (rest := rest) (t1 := t1) (e := [.mov f (t.nu c)])
      hd hc rfl rfl hval i4
    rw [he]
    refine ⟨?_, ?_, ?_, o6, ?_, ?_, ?_, ?_, ?_⟩
    · intro r hr1 hr2
      rw [o1, o2, hrun]
      have : t.nu r ≠ f := Nat.ne_of_lt (n4 r hr1 hr2)
      have hrd : r ≠ d := by omega
      simp [step, upd, show t1.nu = t.nu from rfl, this, i1 r hr1 hr2, hrd]
    · intro i hi hli
      rw [o1, o3, o4, hrun]
      by_cases hid : i = d
      · subst hid
        rw [hGd]; simp [step, upd, show t1.nu = t.nu from rfl, hqd, i1 c hc hcB]
      · rw [hGo i hid]
        have hla_i : loadAhead n i (.mov d c :: rest) = true := by rw [hla i hi hid]; exact hli
        have : t.G i (t.seg i) ≠ f := Nat.ne_of_lt (n5 i hi hla_i)
        simp [step, upd, show t1.nu = t.nu from rfl, this, i2 i hi hla_i, hid]
    · rw [o1, hrun]; exact i3
    · intro r r' hr1 hr2 hr1' hr2' he'; rw [o2] at he'; exact n1 r r' hr1 hr2 hr1' hr2' he'
    · intro r hr1 hr2 i hi hli
      rw [o2, o3, o4]
      by_cases hid : i = d
      · subst hid; rw [hGd]; exact Nat.ne_of_lt (n4 r hr1 hr2)
      · rw [hGo i hid]; exact n2 r hr1 hr2 i hi (by rw [hla i hi hid]; exact hli)
    · intro i j hi hj hij hli hlj
      rw [o3, o4]
      by_cases hid : i = d
      · subst hid
        have hjd : j ≠ i := Ne.symm hij
        rw [hGd, hGo j hjd]
        exact Ne.symm (Nat.ne_of_lt (n5 j hj (by rw [hla j hj hjd]; exact hlj)))
      · by_cases hjd : j = d
        · subst hjd
          rw [hGd, hGo i hid]
          exact Nat.ne_of_lt (n5 i hi (by rw [hla i hi hid]; exact hli))
        · rw [hGo i hid, hGo j hjd]
          exact n3 i j hi hj hij (by rw [hla i hi hid]; exact hli) (by rw [hla j hj hjd]; exact hlj)
    · intro r hr1 hr2; rw [o2, o5]; have := n4 r hr1 hr2; simp [t1, f]; omega
    · intro i hi hli
      rw [o3, o4, o5]
      by_cases hid : i = d
      · subst hid; rw [hGd]; simp [t1, f]
      · rw [hGo i hid]
        have := n5 i hi (by rw [hla i hi hid]; exact hli)
        simp [t1, f]; omega
  · have hl' : loadAhead n d rest = false := by simpa using hl
    let t1 : TS := { t with seg := upd t.seg d k }
    have he : trStep n t (.mov d c) rest =
        if storeAhead n d rest then t1 else { t1 with snap := upd t1.snap d (t.nu c, t1.out.length) } := by
      simp [trStep, hcn, hd, hl', t1, k]
    have hGo : ∀ i, i ≠ d → t1.G i (t1.seg i) = t.G i (t.seg i) := by
      intro i hid; simp [t1, upd, hid]
    have hnd : ∀ i < n, loadAhead n i rest = true → i ≠ d := by
      intro i _ hli hid; subst hid; rw [hl'] at hli; exact Bool.false_ne_true hli
    have hval : (run compare t1.out init).regs (t.nu c) = qs.regs c := i1 c hc hcB
    obtain ⟨o1, o2, o3, o4, o5, o6⟩ := store_snap (rest := rest) (t1 := t1) (e := [])
      hd hc (by simp [t1]) rfl hval i4
    rw [he]
    refine ⟨?_, ?_, ?_, o6, ?_, ?_, ?_, ?_, ?_⟩
    · intro r hr1 hr2
      rw [o1, o2]
      have hrd : r ≠ d := by omega
      rw [hq r hrd]; exact i1 r hr1 hr2
    · intro i hi hli
      have hid := hnd i hi hli
      rw [o1, o3, o4, hGo i hid, hq i hid]
      exact i2 i hi (by rw [hla i hi hid]; exact hli)
    · rw [o1]; exact i3
    · intro r r' hr1 hr2 hr1' hr2' he'; rw [o2] at he'; exact n1 r r' hr1 hr2 hr1' hr2' he'
    · intro r hr1 hr2 i hi hli
      have hid := hnd i hi hli
      rw [o2, o3, o4, hGo i hid]
      exact n2 r hr1 hr2 i hi (by rw [hla i hi hid]; exact hli)
    · intro i j hi hj hij hli hlj
      have hid := hnd i hi hli; have hjd := hnd j hj hlj
      rw [o3, o4, hGo i hid, hGo j hjd]
      exact n3 i j hi hj hij (by rw [hla i hi hid]; exact hli) (by rw [hla j hj hjd]; exact hlj)
    · intro r hr1 hr2; rw [o2, o5]; exact n4 r hr1 hr2
    · intro i hi hli
      have hid := hnd i hi hli
      rw [o3, o4, o5, hGo i hid]
      exact n5 i hi (by rw [hla i hi hid]; exact hli)


/-! ### Whole run -/

theorem inv_step {n B : Nat} {t : TS} {ins : Instr} {rest : Program} {qs init : State Int}
    (hmm : MMInstr n ins) (hlt : ∀ r ∈ ins.regs, r < B) (h : Inv n B t (ins :: rest) qs init) :
    Inv n B (trStep n t ins rest) rest (step compare qs ins) init := by
  cases ins with
  | mov d s =>
    simp only [MMInstr] at hmm
    by_cases hs : s < n
    · exact inv_step_load hs (by omega) (hlt d (by simp [Instr.regs])) h
    · by_cases hd : d < n
      · exact inv_step_store hd (by omega) (hlt s (by simp [Instr.regs])) h
      · apply inv_step_reg _ hlt _ h
        · intro r hr; simp [Instr.regs] at hr; omega
        · rintro ⟨d', s', he, h'⟩; cases he; omega
  | cmp a b =>
    simp only [MMInstr] at hmm
    apply inv_step_reg _ hlt _ h
    · intro r hr; simp [Instr.regs] at hr; omega
    · rintro ⟨d', s', he, _⟩; cases he
  | cmov c d s =>
    simp only [MMInstr] at hmm
    apply inv_step_reg _ hlt _ h
    · intro r hr; simp [Instr.regs] at hr; omega
    · rintro ⟨d', s', he, _⟩; cases he

theorem inv_run {n B : Nat} {init : State Int} :
    ∀ (q : Program) (t : TS) (qs : State Int), MMProg n q → (∀ i ∈ q, ∀ r ∈ i.regs, r < B) →
      Inv n B t q qs init → Inv n B (tr n t q) [] (run compare q qs) init
  | [], _, _, _, _, h => h
  | ins :: rest, t, qs, hmm, hlt, h => by
    simp only [tr, run_cons]
    exact inv_run rest _ _ (fun i hi => hmm i (by simp [hi])) (fun i hi => hlt i (by simp [hi]))
      (inv_step (hmm ins (by simp)) (hlt ins (by simp)) h)

theorem inv_init (n B : Nat) (hB : n ≤ B) (q : Program) (init : State Int) :
    Inv n B (t0 B) q init init := by
  refine ⟨fun r _ _ => rfl, fun i _ _ => rfl, rfl, fun i _ _ => ⟨Nat.le_refl _, rfl⟩,
    fun r r' _ _ _ _ h => h, ?_, ?_, fun r _ hr => hr, fun i hi _ => by simp only [t0]; omega⟩
  · intro r hr1 _ i hi _; simp [t0]; omega
  · intro i j _ _ hij _ _; simpa [t0] using hij

/-! ### Length count -/

def savedI (n i : Nat) : Program → Nat
  | [] => 0
  | ins :: rest => savedI n i rest +
      (if (isLoad n i ins || isStore n i ins) && !loadAhead n i rest then 1 else 0)

def storesI (n i : Nat) : Program → Nat
  | [] => 0
  | ins :: rest => storesI n i rest + (if isStore n i ins then 1 else 0)

theorem not_load_and_store {n i : Nat} {ins : Instr} (h1 : isLoad n i ins = true) :
    isStore n i ins = false := by
  cases ins <;> simp_all [isLoad, isStore] <;> omega

theorem savedI_eq (n i : Nat) (q : Program) :
    savedI n i q = storesI n i q + (if nextI n i q = some true then 1 else 0) := by
  induction q with
  | nil => simp [savedI, storesI, nextI]
  | cons ins rest ih =>
    simp only [savedI, storesI, ih, loadAhead]
    by_cases hL : isLoad n i ins = true
    · have hS := not_load_and_store hL
      simp only [nextI, hL, hS, if_true]
      by_cases hn : nextI n i rest = some true <;> simp [hn]
    · have hL' : isLoad n i ins = false := by simpa using hL
      by_cases hS : isStore n i ins = true
      · simp only [nextI, hL', hS]
        by_cases hn : nextI n i rest = some true <;> simp [hn]
      · have hS' : isStore n i ins = false := by simpa using hS
        simp [nextI, hL', hS']

def sumTo : Nat → (Nat → Nat) → Nat
  | 0, _ => 0
  | m + 1, f => sumTo m f + f m

theorem sumTo_add (m : Nat) (f g : Nat → Nat) :
    sumTo m (fun i => f i + g i) = sumTo m f + sumTo m g := by
  induction m with
  | zero => rfl
  | succ m ih => simp only [sumTo, ih]; omega

theorem sumTo_zero (m : Nat) (f : Nat → Nat) (h : ∀ i < m, f i = 0) : sumTo m f = 0 := by
  induction m with
  | zero => rfl
  | succ m ih => simp only [sumTo, ih (fun i hi => h i (by omega)), h m (by omega)]

theorem sumTo_single (m c : Nat) (f : Nat → Nat) (hc : c < m) (h : ∀ i < m, i ≠ c → f i = 0) :
    sumTo m f = f c := by
  induction m with
  | zero => omega
  | succ m ih =>
    simp only [sumTo]
    by_cases hm : c = m
    · subst hm
      rw [sumTo_zero c f (fun i hi => h i (by omega) (by omega))]; omega
    · rw [ih (by omega) (fun i hi hic => h i (by omega) hic), h m (by omega) (Ne.symm hm)]; omega

theorem sumTo_ge (m a : Nat) (f : Nat → Nat) (h : ∀ i < m, a ≤ f i) : m * a ≤ sumTo m f := by
  induction m with
  | zero => simp [sumTo]
  | succ m ih =>
    simp only [sumTo, Nat.succ_mul]
    have := ih (fun i hi => h i (by omega)); have := h m (by omega); omega

theorem mem_regs_mm {n i : Nat} {ins : Instr} (hmm : MMInstr n ins) (hi : i < n)
    (h : i ∈ ins.regs) : isLoad n i ins = true ∨ isStore n i ins = true := by
  cases ins with
  | mov d s =>
    simp only [MMInstr] at hmm
    simp only [Instr.regs, List.mem_cons, List.mem_nil_iff, or_false] at h
    rcases h with rfl | rfl
    · right; simp [isStore, hi]; omega
    · left; simp [isLoad, hi]; omega
  | cmp a b =>
    simp only [MMInstr] at hmm; simp [Instr.regs] at h; omega
  | cmov c d s =>
    simp only [MMInstr] at hmm; simp [Instr.regs] at h; omega

/-- Emitted length + saved instructions = 1 per instruction. -/
theorem trStep_len {n : Nat} (t : TS) (ins : Instr) (rest : Program) (hmm : MMInstr n ins) :
    (trStep n t ins rest).out.length +
      sumTo n (fun i => if (isLoad n i ins || isStore n i ins) && !loadAhead n i rest then 1 else 0)
      = t.out.length + 1 := by
  cases ins with
  | mov d s =>
    simp only [MMInstr] at hmm
    by_cases hs : s < n
    · have hd : n ≤ d := by omega
      rw [sumTo_single n s _ hs (fun i hi his => by
        simp [isLoad, isStore, Ne.symm his]; intros; omega)]
      have hL : isLoad n s (.mov d s) = true := by simp [isLoad, hs, hd]
      by_cases hl : loadAhead n s rest = true
      · simp [trStep, hs, hl, hL]
      · have hl' : loadAhead n s rest = false := by simpa using hl
        simp [trStep, hs, hl', hL]
    · by_cases hd : d < n
      · have hsn : n ≤ s := by omega
        rw [sumTo_single n d _ hd (fun i hi hid => by
          simp [isLoad, isStore, Ne.symm hid]; intros; omega)]
        have hS : isStore n d (.mov d s) = true := by simp [isStore, hd, hsn]
        have hsn' : ¬ s < n := by omega
        by_cases hl : loadAhead n d rest = true
        · by_cases hsa : storeAhead n d rest = true
          · simp [trStep, hsn', hd, hl, hsa, hS]
          · have hsa' : storeAhead n d rest = false := by simpa using hsa
            simp [trStep, hsn', hd, hl, hsa', hS]
        · have hl' : loadAhead n d rest = false := by simpa using hl
          by_cases hsa : storeAhead n d rest = true
          · simp [trStep, hsn', hd, hl', hsa, hS]
          · have hsa' : storeAhead n d rest = false := by simpa using hsa
            simp [trStep, hsn', hd, hl', hsa', hS]
      · rw [sumTo_zero n _ (fun i hi => by simp [isLoad, isStore]; intro h; exfalso; omega)]
        simp [trStep, hs, hd]
  | cmp a b =>
    rw [sumTo_zero n _ (fun i hi => by simp [isLoad, isStore])]; simp [trStep]
  | cmov c d s =>
    rw [sumTo_zero n _ (fun i hi => by simp [isLoad, isStore])]; simp [trStep]

theorem tr_len {n : Nat} : ∀ (q : Program) (t : TS), MMProg n q →
    (tr n t q).out.length + sumTo n (fun i => savedI n i q) = t.out.length + q.length
  | [], t, _ => by simp [tr, savedI, sumTo_zero]
  | ins :: rest, t, hmm => by
    simp only [tr, savedI]
    rw [sumTo_add]
    have h1 := tr_len rest (trStep n t ins rest) (fun i hi => hmm i (by simp [hi]))
    have h2 := trStep_len t ins rest (hmm ins (by simp))
    simp only [List.length_cons]
    omega


/-! ### (b) every cell is stored, (a) the first access of a cell is a load -/

theorem run_cell_fixed {n i : Nat} (hi : i < n) :
    ∀ (q : Program) (s : State Int), MMProg n q → storesI n i q = 0 →
      (run compare q s).regs i = s.regs i
  | [], _, _, _ => rfl
  | ins :: rest, s, hmm, h0 => by
    simp only [storesI] at h0
    have hS : isStore n i ins = false := by
      cases e : isStore n i ins
      · rfl
      · rw [e] at h0; simp at h0
    have h0' : storesI n i rest = 0 := by omega
    simp only [run_cons]
    rw [run_cell_fixed hi rest _ (fun j hj => hmm j (by simp [hj])) h0']
    have hm := hmm ins (by simp)
    cases ins with
    | mov d c =>
      simp only [MMInstr] at hm
      have hdi : d ≠ i := by
        intro e; subst e
        simp [isStore, hi] at hS; omega
      simp [step, upd, Ne.symm hdi]
    | cmp a b => rfl
    | cmov cc d c =>
      simp only [MMInstr] at hm
      simp only [step]; split
      · simp [upd]; intro; omega
      · rfl

/-- The vector with one special entry. -/
def ind (i : Nat) (a b : Int) : Nat → Int := fun k => if k = i then a else b

theorem cnt_ind' (i : Nat) (a b t : Int) (m : Nat) :
    cnt (ind i a b) t m =
      (if i < m ∧ a < t then 1 else 0) + (if b < t then (if i < m then m - 1 else m) else 0) :=
  cnt_ind i a b t m

theorem relaxed_out {n : Nat} {q : Program} (h : RelaxedCorrect n q) (x : Nat → Int)
    (hx : ∀ k < n, x k < 2) : SortsOK n x (run compare q (relaxInit n x 2)).regs := h x 2 hx

theorem stores_pos {n : Nat} {q : Program} (hn : 2 ≤ n) (hmm : MMProg n q) (h : RelaxedCorrect n q) :
    ∀ i < n, 1 ≤ storesI n i q := by
  intro i hi
  apply Nat.pos_of_ne_zero
  intro h0
  have fixed := fun x => run_cell_fixed hi q (relaxInit n x 2) hmm h0
  by_cases hi1 : 1 ≤ i
  · let x := ind i 0 1
    have hc := relaxed_out h x (fun k _ => by simp only [x, ind]; split <;> omega)
    have := sortsOK_rank_le hc hi
    have v : (relaxInit n x 2).regs i = 0 := by simp [relaxInit, hi, x, ind]
    rw [fixed x, v] at this
    have e : cnt x (0 + 1) n = 1 := by simp only [x, cnt_ind']; simp [hi]
    omega
  · have hi0 : i = 0 := by omega
    subst hi0
    let x := ind 0 1 0
    have hc := relaxed_out h x (fun k _ => by simp only [x, ind]; split <;> omega)
    have := sortsOK_rank_lt hc hi
    have v : (relaxInit n x 2).regs 0 = 1 := by simp [relaxInit, hi, x, ind]
    rw [fixed x, v] at this
    have e : cnt x 1 n = n - 1 := by simp only [x, cnt_ind']; simp [hi]
    omega

theorem nextI_none_stores {n i : Nat} : ∀ q : Program, nextI n i q = none → storesI n i q = 0
  | [], _ => rfl
  | ins :: rest, h => by
    simp only [nextI] at h
    by_cases hL : isLoad n i ins = true
    · simp [hL] at h
    · by_cases hS : isStore n i ins = true
      · simp [hL, hS] at h
      · have hL' : isLoad n i ins = false := by simpa using hL
        have hS' : isStore n i ins = false := by simpa using hS
        simp only [hL', hS'] at h
        simp [storesI, hS', nextI_none_stores rest h]

def Agree (i : Nat) (s1 s2 : State Int) : Prop := (∀ r, r ≠ i → s1.regs r = s2.regs r) ∧ s1.flag = s2.flag

theorem step_agree {i : Nat} {s1 s2 : State Int} {ins : Instr} (hi : i ∉ ins.regs) (h : Agree i s1 s2) :
    Agree i (step compare s1 ins) (step compare s2 ins) := by
  obtain ⟨hr, hf⟩ := h
  cases ins with
  | mov d c =>
    have hd : d ≠ i := fun e => hi (by simp [Instr.regs, e])
    have hc : c ≠ i := fun e => hi (by simp [Instr.regs, e])
    refine ⟨fun r hri => ?_, hf⟩
    simp only [step, upd]; split
    · exact hr c hc
    · exact hr r hri
  | cmp a b =>
    have ha : a ≠ i := fun e => hi (by simp [Instr.regs, e])
    have hb : b ≠ i := fun e => hi (by simp [Instr.regs, e])
    exact ⟨fun r hri => hr r hri, by simp only [step, hr a ha, hr b hb]⟩
  | cmov cc d c =>
    have hd : d ≠ i := fun e => hi (by simp [Instr.regs, e])
    have hc : c ≠ i := fun e => hi (by simp [Instr.regs, e])
    simp only [step, hf]
    split
    · refine ⟨fun r hri => ?_, rfl⟩
      simp only [upd]; split
      · exact hr c hc
      · exact hr r hri
    · exact ⟨hr, hf⟩

theorem run_eq_store_first {n i : Nat} (hi : i < n) :
    ∀ (q : Program) (s1 s2 : State Int), MMProg n q → nextI n i q = some false → Agree i s1 s2 →
      run compare q s1 = run compare q s2
  | [], _, _, _, h, _ => by simp [nextI] at h
  | ins :: rest, s1, s2, hmm, hnx, hag => by
    simp only [run_cons]
    have hm := hmm ins (by simp)
    have hmm' : MMProg n rest := fun j hj => hmm j (by simp [hj])
    by_cases hL : isLoad n i ins = true
    · simp [nextI, hL] at hnx
    · have hL' : isLoad n i ins = false := by simpa using hL
      by_cases hS : isStore n i ins = true
      · -- the store overwrites cell i: states become equal
        cases ins with
        | mov d c =>
          simp only [isStore, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hS
          obtain ⟨⟨rfl, _⟩, hc⟩ := hS
          have hci : c ≠ d := by omega
          have : step compare s1 (.mov d c) = step compare s2 (.mov d c) := by
            simp only [step]
            have e1 : upd s1.regs d (s1.regs c) = upd s2.regs d (s2.regs c) := by
              funext r; simp only [upd]; split
              · exact hag.1 c hci
              · rename_i hrd; exact hag.1 r hrd
            rw [e1, hag.2]
          rw [this]
        | cmp a b => simp [isStore] at hS
        | cmov cc d c => simp [isStore] at hS
      · have hS' : isStore n i ins = false := by simpa using hS
        have hnx' : nextI n i rest = some false := by simpa [nextI, hL', hS'] using hnx
        have hni : i ∉ ins.regs := by
          intro hmem
          rcases mem_regs_mm hm hi hmem with h1 | h1
          · rw [hL'] at h1; exact Bool.false_ne_true h1
          · rw [hS'] at h1; exact Bool.false_ne_true h1
        exact run_eq_store_first hi rest _ _ hmm' hnx' (step_agree hni hag)

theorem first_load {n : Nat} {q : Program} (hn : 2 ≤ n) (hmm : MMProg n q) (h : RelaxedCorrect n q) :
    ∀ i < n, nextI n i q = some true := by
  intro i hi
  cases hnx : nextI n i q with
  | none =>
    have := stores_pos hn hmm h i hi
    rw [nextI_none_stores q hnx] at this; omega
  | some b =>
    cases b with
    | true => rfl
    | false =>
      exfalso
      let x := ind i 0 0
      let x' := ind i 1 0
      have hag : Agree i (relaxInit n x 2) (relaxInit n x' 2) := by
        refine ⟨fun r hri => ?_, rfl⟩
        simp only [relaxInit, x, x', ind, hri, if_false]
      have heq := run_eq_store_first hi q _ _ hmm hnx hag
      have h1 := relaxed_out h x (fun k _ => by simp only [x, ind]; split <;> omega)
      have h2 := relaxed_out h x' (fun k _ => by simp only [x', ind]; split <;> omega)
      rw [heq] at h1
      have c1 := sortsOK_cnt h1 1
      have c2 := sortsOK_cnt h2 1
      rw [← c2] at c1
      simp only [x, x', cnt_ind'] at c1
      revert c1; simp [hi] <;> omega

theorem savedI_ge2 {n : Nat} {q : Program} (hn : 2 ≤ n) (hmm : MMProg n q) (h : RelaxedCorrect n q) :
    ∀ i < n, 2 ≤ savedI n i q := by
  intro i hi
  rw [savedI_eq, first_load hn hmm h i hi]
  have := stores_pos hn hmm h i hi
  simp; omega


/-! ### Opcodes are preserved -/

theorem trStep_inSet (iset : Cond → Bool) (n : Nat) (t : TS) (ins : Instr) (rest : Program)
    (hins : ins.inSet iset = true) :
    ∀ j ∈ (trStep n t ins rest).out, j ∈ t.out ∨ j.inSet iset = true := by
  intro j hj
  cases ins with
  | mov d s =>
    simp only [trStep] at hj
    repeat' split at hj
    all_goals (simp only [List.mem_append, List.mem_singleton] at hj)
    all_goals (first | exact Or.inl hj | (rcases hj with hj | rfl; exact Or.inl hj; exact Or.inr rfl))
  | cmp a b =>
    simp only [trStep, List.mem_append, List.mem_singleton] at hj
    rcases hj with hj | rfl
    · exact Or.inl hj
    · exact Or.inr rfl
  | cmov c d s =>
    simp only [trStep, List.mem_append, List.mem_singleton] at hj
    rcases hj with hj | rfl
    · exact Or.inl hj
    · exact Or.inr hins

theorem tr_inSet (iset : Cond → Bool) (n : Nat) :
    ∀ (q : Program) (t : TS), (∀ i ∈ q, i.inSet iset = true) → (∀ i ∈ t.out, i.inSet iset = true) →
      ∀ i ∈ (tr n t q).out, i.inSet iset = true
  | [], t, _, ht => ht
  | ins :: rest, t, hq, ht => by
    simp only [tr]
    apply tr_inSet iset n rest _ (fun i hi => hq i (by simp [hi]))
    intro j hj
    rcases trStep_inSet iset n t ins rest (hq ins (by simp)) j hj with h | h
    · exact ht j h
    · exact h

/-! ### L5 and the main theorem -/

/-- Lemma L5 (relaxed form). -/
theorem l5 {n : Nat} {q : Program} (hn : 2 ≤ n) (hq : MMProg n q) (h : RelaxedCorrect n q) :
    ∃ (p : Program) (o : Snap), p.length + 2 * n ≤ q.length ∧
      (∀ iset : Cond → Bool, (∀ i ∈ q, i.inSet iset) → ∀ i ∈ p, i.inSet iset) ∧ RelaxedSnap n p o := by
  let B := maxReg q + n + 1
  let t := tr n (t0 B) q
  refine ⟨t.out, t.snap, ?_, ?_, ?_⟩
  · have h1 := tr_len q (t0 B) hq
    have h2 := sumTo_ge n 2 _ (savedI_ge2 hn hq h)
    have h0 : (t0 B).out.length = 0 := rfl
    rw [h0] at h1
    show (tr n (t0 B) q).out.length + 2 * n ≤ q.length
    rw [Nat.mul_comm]; omega
  · intro iset hset
    exact tr_inSet iset n q (t0 B) hset (by simp [t0])
  · intro x T hx
    have hinv := inv_run (init := relaxInit n x T) q (t0 B) (relaxInit n x T) hq
      (fun i hi r hr => by have := regs_lt_maxReg i hi r hr; omega)
      (inv_init n B (by omega) q _)
    have hc := h x T hx
    refine (sortsOK_congr (fun _ _ => rfl) (fun j hj => ?_)).mp hc
    obtain ⟨_, hv⟩ := hinv.i4 j hj (by simp [storeAhead])
    simp only [snapOut]; exact hv.symm

/-- The relaxed half of `lower_bound_chain_snap`. -/
theorem relaxed_chain_snap (n k : Nat) (iset : Cond → Bool) (hn : 2 ≤ n)
    (H : ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedSnap n p o) :
    ∀ (p : Program) (o : Snap), p.length ≤ k → (∀ i ∈ p, i.inSet iset) → ¬ RelaxedSnap n p o := by
  intro p o hk hset hr
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

/-- Main theorem (MM, AlphaDev counting). Hypothesis = the rule-free RS search at length `K`
  (registers `< n + K`, snapshots `reg < n + K`, positions `≤ K`, opcodes in `iset`, relaxed).
  Conclusion: no MM program (cells `0..n-1`, MM-1) of length `≤ K + 2n`, opcodes in `iset`,
  sorts on x86 (all 32-bit inputs, all garbage, all flag states). -/
theorem mm_lower_bound (n K : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ (p : Program) (o : Snap), p.length = K → Program.WF (n + K) p →
      (∀ j, (o j).1 < n + K) → (∀ j, (o j).2 ≤ K) → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedSnap n p o) :
    ∀ q : Program, MMProg n q → q.length ≤ K + 2 * n → (∀ i ∈ q, i.inSet iset) → ¬ XCorrect n q := by
  intro q hmm hlen hset hx
  have hr := xcorrect_to_relaxed hn' hx
  obtain ⟨p, o, hl, hs, hp⟩ := l5 hn hmm hr
  exact relaxed_chain_snap n K iset hn H p o (by omega) (hs iset hset) hp

end SortProof
