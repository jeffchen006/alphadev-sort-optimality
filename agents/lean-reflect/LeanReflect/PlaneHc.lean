import LeanReflect.PlaneDefs
import LeanReflect.Lemmas
/-
  The fast (bit-plane) H1 bound `hcP2` and the capped cover bound `maxCoverBP` equal the list spec after decoding.
  Note: `hcP2_eq` as first stated (with only `FCOK f` and `WFkey f.c k`) is false: `FCOK` does not bound the
  input indices `f.inv` (they come from the arbitrary `f.c.ts`), and the base-5 row codes collide when an index is
  ≥ 5 (see `hcP2_eq_false`). `hcP2_eq_of_inv5` adds the bound `f.inv … < 5` (true for `mkCtx n`, `n ≤ 4`).
-/
namespace LeanReflect.FP
open SortProof LeanReflect
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

section hcPriv

/-! ## bit facts -/

private theorem hc_tb (x : UInt64) (i : Nat) : x.toNat.testBit i = x.toBitVec.getLsbD i :=
  BitVec.testBit_toNat _

private theorem hc_tb_ge64 (x : UInt64) {i : Nat} (hi : 64 ≤ i) : x.toNat.testBit i = false :=
  Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le (UInt64.toNat_lt x) (Nat.pow_le_pow_right (by decide) hi))

private theorem hc_not_tb (x : UInt64) (i : Nat) :
    (~~~x).toNat.testBit i = (decide (i < 64) && !x.toNat.testBit i) := by
  simp only [hc_tb, UInt64.toBitVec_not, BitVec.getLsbD_not]

private theorem hc_and_tb (x y : UInt64) (i : Nat) :
    (x &&& y).toNat.testBit i = (x.toNat.testBit i && y.toNat.testBit i) := by
  rw [UInt64.toNat_and, Nat.testBit_and]

private theorem hc_or_tb (x y : UInt64) (i : Nat) :
    (x ||| y).toNat.testBit i = (x.toNat.testBit i || y.toNat.testBit i) := by
  rw [UInt64.toNat_or, Nat.testBit_or]

private theorem hc_shr32_tb (x : UInt64) (i : Nat) : (x >>> 32).toNat.testBit i = x.toNat.testBit (32 + i) := by
  rw [UInt64.toNat_shiftRight, Nat.testBit_shiftRight]; rfl

private theorem hc_M32_tb (i : Nat) : M32.toNat.testBit i = decide (i < 32) := by
  have : M32.toNat = 2 ^ 32 - 1 := rfl
  rw [this, Nat.testBit_two_pow_sub_one]

private theorem hc_toUInt64 {t : Nat} (ht : t < 64) : t.toUInt64.toNat = t := by
  simp only [Nat.toUInt64, UInt64.toNat_ofNat']
  exact Nat.mod_eq_of_lt (Nat.lt_trans ht (by decide))

private theorem hc_and_pow (y b : UInt64) (s : Nat) (hb : b.toNat = 2 ^ s) :
    (y &&& b != 0) = y.toNat.testBit s := by
  rw [Bool.eq_iff_iff, bne_iff_ne, ne_eq, ← UInt64.toNat_inj, UInt64.toNat_zero]
  constructor
  · intro hne
    cases h : y.toNat.testBit s
    · exfalso; apply hne
      apply Nat.eq_of_testBit_eq; intro i
      rw [hc_and_tb, hb, Nat.testBit_two_pow, Nat.zero_testBit]
      by_cases hi : s = i
      · subst hi; simp [h]
      · simp [hi]
    · rfl
  · intro h hz
    have := congrArg (fun z => z.testBit s) hz
    simp only [hc_and_tb, hb, Nat.testBit_two_pow, h, Nat.zero_testBit] at this
    simp at this

private theorem hc_bit1 (x : UInt64) {t : Nat} (ht : t < 64) :
    (x &&& (1 : UInt64) <<< t.toUInt64 != 0) = x.toNat.testBit t := by
  apply hc_and_pow
  rw [UInt64.toNat_shiftLeft, hc_toUInt64 ht, Nat.mod_eq_of_lt ht]
  have : (1 : UInt64).toNat = 1 := rfl
  rw [this, Nat.shiftLeft_eq, Nat.one_mul]
  exact Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (by decide) ht)

private theorem hc_flbit (fl : UInt64) {t : Nat} (ht : t < 64) :
    ((fl >>> t.toUInt64) &&& 1 != 0) = fl.toNat.testBit t := by
  rw [hc_and_pow _ 1 0 rfl, UInt64.toNat_shiftRight, Nat.testBit_shiftRight, hc_toUInt64 ht, Nat.mod_eq_of_lt ht,
    Nat.add_zero]

private theorem hc_pb0 (p : PCol) (t : Nat) : planeBit p 0 t = bitU p.lo t := by simp [planeBit]
private theorem hc_pb1 (p : PCol) (t : Nat) : planeBit p 1 t = bitU p.lo (32 + t) := by simp [planeBit]
private theorem hc_pb2 (p : PCol) (t : Nat) : planeBit p 2 t = bitU p.hi t := by simp [planeBit]
private theorem hc_pb3 (p : PCol) (t : Nat) : planeBit p 3 t = bitU p.hi (32 + t) := by simp [planeBit]

private theorem hc_p0 (p : PCol) (t : Nat) : p.p0.toNat.testBit t = (decide (t < 32) && planeBit p 0 t) := by
  simp only [PCol.p0, hc_and_tb, hc_M32_tb, hc_pb0, bitU, Bool.and_comm]
private theorem hc_p1 (p : PCol) (t : Nat) : p.p1.toNat.testBit t = (decide (t < 32) && planeBit p 1 t) := by
  simp only [PCol.p1, hc_shr32_tb, hc_pb1, bitU]
  by_cases ht : t < 32
  · simp [ht]
  · simp [ht, hc_tb_ge64 p.lo (show 64 ≤ 32 + t by omega)]
private theorem hc_p2 (p : PCol) (t : Nat) : p.p2.toNat.testBit t = (decide (t < 32) && planeBit p 2 t) := by
  simp only [PCol.p2, hc_and_tb, hc_M32_tb, hc_pb2, bitU, Bool.and_comm]
private theorem hc_p3 (p : PCol) (t : Nat) : p.p3.toNat.testBit t = (decide (t < 32) && planeBit p 3 t) := by
  simp only [PCol.p3, hc_shr32_tb, hc_pb3, bitU]
  by_cases ht : t < 32
  · simp [ht]
  · simp [ht, hc_tb_ge64 p.hi (show 64 ≤ 32 + t by omega)]

private theorem hc_oh0 (p : PCol) (t : Nat) : (p.oh 0).toNat.testBit t = (decide (t < 32) && planeBit p 0 t) := by
  simp only [PCol.oh, hc_p0]
private theorem hc_oh1 (p : PCol) (t : Nat) :
    (p.oh 1).toNat.testBit t = (decide (t < 32) && planeBit p 1 t && !planeBit p 0 t) := by
  simp only [PCol.oh, hc_and_tb, hc_not_tb, hc_p0, hc_p1]
  by_cases ht : t < 32
  · have : t < 64 := by omega
    simp [ht, this]
  · simp [ht]
private theorem hc_oh2 (p : PCol) (t : Nat) :
    (p.oh 2).toNat.testBit t = (decide (t < 32) && planeBit p 2 t && !planeBit p 0 t && !planeBit p 1 t) := by
  simp only [PCol.oh, hc_and_tb, hc_not_tb, hc_or_tb, hc_p0, hc_p1, hc_p2]
  by_cases ht : t < 32
  · have : t < 64 := by omega
    simp [ht, this]; cases planeBit p 0 t <;> cases planeBit p 1 t <;> simp
  · simp [ht]
private theorem hc_oh3 (p : PCol) (t : Nat) :
    (p.oh 3).toNat.testBit t =
      (decide (t < 32) && planeBit p 3 t && !planeBit p 0 t && !planeBit p 1 t && !planeBit p 2 t) := by
  simp only [PCol.oh, hc_and_tb, hc_not_tb, hc_or_tb, hc_p0, hc_p1, hc_p2, hc_p3]
  by_cases ht : t < 32
  · have : t < 64 := by omega
    simp [ht, this]; cases planeBit p 0 t <;> cases planeBit p 1 t <;> cases planeBit p 2 t <;> simp
  · simp [ht]

/-! ## lane values as functions of the four plane bits -/

private def lvB (n : Nat) (b0 b1 b2 b3 : Bool) : Nat :=
  if 1 ≤ n ∧ b0 = true then 0 else if 2 ≤ n ∧ b1 = true then 1 else
  if 3 ≤ n ∧ b2 = true then 2 else if 4 ≤ n ∧ b3 = true then 3 else n

private def lvF (n : Nat) (b0 b1 b2 b3 : Bool) : Nat :=
  if b0 = true then 0 else if n ≤ 1 then n else
  if b1 = true then 1 else if n ≤ 2 then n else
  if b2 = true then 2 else if n ≤ 3 then n else
  if b3 = true then 3 else n

private def ohB : Nat → Bool → Bool → Bool → Bool → Bool
  | 0, b0, _, _, _ => b0
  | 1, b0, b1, _, _ => b1 && !b0
  | 2, b0, b1, b2, _ => b2 && !b0 && !b1
  | _, b0, b1, b2, b3 => b3 && !b0 && !b1 && !b2

private def selB : Nat → Bool → Bool → Bool → Bool → Bool
  | 0, b0, _, _, _ => b0
  | 1, _, b1, _, _ => b1
  | 2, _, _, b2, _ => b2
  | _, _, _, _, b3 => b3

private theorem hc_core_lv (n : Nat) (hn : n < 5) (hn1 : 1 ≤ n) :
    ∀ b0 b1 b2 b3 : Bool, lvF n b0 b1 b2 b3 = lvB n b0 b1 b2 b3 := by
  have : n = 1 ∨ n = 2 ∨ n = 3 ∨ n = 4 := by omega
  rcases this with rfl | rfl | rfl | rfl <;> decide

private theorem hc_core_oh (n : Nat) (hn : n < 5) (j : Nat) (hj : j < n) : ∀ M b0 b1 b2 b3 : Bool,
    (b0 = true → M = true) → (b1 = true → M = true ∧ 1 < n ∧ b0 = false) →
    (b2 = true → M = true ∧ 2 < n ∧ b0 = false ∧ b1 = false) →
    (b3 = true → M = true ∧ 3 < n ∧ b0 = false ∧ b1 = false ∧ b2 = false) →
    ohB j b0 b1 b2 b3 = (M && lvB n b0 b1 b2 b3 == j) := by
  have : n = 1 ∨ n = 2 ∨ n = 3 ∨ n = 4 := by omega
  have hj' : j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 := by omega
  rcases this with rfl | rfl | rfl | rfl <;> rcases hj' with rfl | rfl | rfl | rfl <;> first | omega | decide

private theorem hc_core_sel (n : Nat) (hn : n < 5) (v : Nat) (hv : v < 4) : ∀ M b0 b1 b2 b3 : Bool,
    (b0 = true → M = true ∧ 0 < n) → (b1 = true → M = true ∧ 1 < n ∧ b0 = false) →
    (b2 = true → M = true ∧ 2 < n ∧ b0 = false ∧ b1 = false) →
    (b3 = true → M = true ∧ 3 < n ∧ b0 = false ∧ b1 = false ∧ b2 = false) →
    selB v b0 b1 b2 b3 = (M && decide (v < n) && lvB n b0 b1 b2 b3 == v) := by
  have : n = 0 ∨ n = 1 ∨ n = 2 ∨ n = 3 ∨ n = 4 := by omega
  have hv' : v = 0 ∨ v = 1 ∨ v = 2 ∨ v = 3 := by omega
  rcases this with rfl | rfl | rfl | rfl | rfl <;> rcases hv' with rfl | rfl | rfl | rfl <;> decide

private theorem hc_laneValS_B (n : Nat) (p : PCol) (t : Nat) :
    laneValS n p t = lvB n (planeBit p 0 t) (planeBit p 1 t) (planeBit p 2 t) (planeBit p 3 t) := rfl

private theorem hc_sel (p : PCol) {v : Nat} (hv : v < 4) (t : Nat) :
    planeBit p v t = selB v (planeBit p 0 t) (planeBit p 1 t) (planeBit p 2 t) (planeBit p 3 t) := by
  match v, hv with
  | 0, _ | 1, _ | 2, _ | 3, _ => rfl

private theorem hc_ohB (p : PCol) {j : Nat} (hj : j < 4) {t : Nat} (ht : t < 32) :
    (p.oh j).toNat.testBit t = ohB j (planeBit p 0 t) (planeBit p 1 t) (planeBit p 2 t) (planeBit p 3 t) := by
  match j, hj with
  | 0, _ => simp [hc_oh0, ht, ohB]
  | 1, _ => simp [hc_oh1, ht, ohB]
  | 2, _ => simp [hc_oh2, ht, ohB]
  | 3, _ => simp [hc_oh3, ht, ohB]

/-- WF facts at one lane, in the form used by the Bool cores. -/
private theorem hc_wf_lane (c : Ctx) {p : PCol} (hp : WFcol c p) {t : Nat} (ht : t < 32) :
    (planeBit p 0 t = true → decide (t < c.m) = true ∧ 0 < c.n) ∧
    (planeBit p 1 t = true → decide (t < c.m) = true ∧ 1 < c.n ∧ planeBit p 0 t = false) ∧
    (planeBit p 2 t = true → decide (t < c.m) = true ∧ 2 < c.n ∧ planeBit p 0 t = false ∧ planeBit p 1 t = false) ∧
    (planeBit p 3 t = true → decide (t < c.m) = true ∧ 3 < c.n ∧ planeBit p 0 t = false ∧
      planeBit p 1 t = false ∧ planeBit p 2 t = false) := by
  have w0 := hp 0 (by decide) t ht
  have w1 := hp 1 (by decide) t ht
  have w2 := hp 2 (by decide) t ht
  have w3 := hp 3 (by decide) t ht
  refine ⟨fun h => ⟨decide_eq_true (w0 h).1, (w0 h).2.1⟩,
    fun h => ⟨decide_eq_true (w1 h).1, (w1 h).2.1, (w1 h).2.2 0 (by decide)⟩,
    fun h => ⟨decide_eq_true (w2 h).1, (w2 h).2.1, (w2 h).2.2 0 (by decide), (w2 h).2.2 1 (by decide)⟩,
    fun h => ⟨decide_eq_true (w3 h).1, (w3 h).2.1, (w3 h).2.2 0 (by decide), (w3 h).2.2 1 (by decide),
      (w3 h).2.2 2 (by decide)⟩⟩

/-- `laneVal` (fast) is `laneValS` on lanes < 32. -/
private theorem hc_laneVal (f : FC) (hf : FCOK f) (p : PCol) {t : Nat} (ht : t < 32) :
    laneVal f p t = laneValS f.c.n p t := by
  have h64 : t < 64 := by omega
  rw [hc_laneValS_B, ← hc_core_lv f.c.n (by have := hf.hn4; omega) hf.hn1]
  simp only [laneVal, lvF, hc_bit1 _ h64, hc_p0, hc_p1, hc_p2, hc_p3, ht, decide_true, Bool.true_and]

private theorem hc_laneValS_le (n : Nat) (p : PCol) (t : Nat) : laneValS n p t ≤ n := by
  simp only [laneValS]
  split
  · omega
  · split
    · omega
    · split
      · omega
      · split
        · omega
        · omega

/-- On a well-formed column, the one-hot plane `j < n` holds exactly the lanes `t < m` of value `j`. -/
private theorem hc_oh_wf (c : Ctx) (hm : c.m ≤ 32) (hn4 : c.n ≤ 4) {p : PCol} (hp : WFcol c p) {j : Nat}
    (hj : j < c.n) (i : Nat) : (p.oh j).toNat.testBit i = decide (i < c.m ∧ laneValS c.n p i = j) := by
  by_cases hi : i < 32
  · obtain ⟨w0, w1, w2, w3⟩ := hc_wf_lane c hp hi
    rw [hc_ohB p (by omega) hi, hc_core_oh c.n (by omega) j hj _ _ _ _ _ (fun h => (w0 h).1) w1 w2 w3,
      hc_laneValS_B]
    generalize lvB c.n _ _ _ _ = L
    by_cases hL : L = j <;> by_cases hm' : i < c.m <;> simp [hL, hm']
  · have hmi : ¬ i < c.m := by omega
    simp only [hmi, false_and, decide_false]
    match j, hj with
    | 0, _ => simp [hc_oh0, hi]
    | 1, _ => simp [hc_oh1, hi]
    | 2, _ => simp [hc_oh2, hi]
    | 3, _ => simp [hc_oh3, hi]
    | j + 4, hj => omega

/-! ## decoding lemmas -/

private theorem hc_decodeCol_getD (c : Ctx) (p : PCol) {i : Nat} (hi : i < c.m) :
    (decodeCol c p).getD i 0 = ((laneValS c.n p i : Nat) : Int) := by
  simp [decodeCol, List.getD_eq_getElem?_getD, List.getElem?_map, List.getElem?_range hi]

private theorem hc_decodeFl_getD (c : Ctx) (fl : UInt64) {i : Nat} (hi : i < c.m) :
    (decodeFl c fl).getD i .eq = (if bitU fl i then .lt else if bitU fl (32 + i) then .gt else .eq) := by
  simp [decodeFl, List.getD_eq_getElem?_getD, List.getElem?_map, List.getElem?_range hi]

private theorem hc_laneFl (f : FC) (fl : UInt64) {t : Nat} (ht : t < 32) :
    laneFl fl t = (if bitU fl t then 0 else if bitU fl (32 + t) then 2 else 1) := by
  simp only [laneFl, hc_flbit fl (show t < 64 by omega), hc_flbit fl (show 32 + t < 64 by omega), bitU]
  by_cases a : fl.toNat.testBit t <;> by_cases b : fl.toNat.testBit (32 + t) <;> simp [a, b]

private theorem hc_fl_code : ∀ a b a' b' : Bool,
    ((if a then 0 else if b then 2 else 1 : Nat) = (if a' then 0 else if b' then 2 else 1 : Nat) ↔
     ((if a then .lt else if b then .gt else .eq : Ordering) = (if a' then .lt else if b' then .gt else .eq))) := by
  decide

/-! ## base-5 codes -/

private theorem hc_enc_inj : ∀ (ds ds' : List Nat) (a a' : Nat), ds.length = ds'.length →
    (∀ d ∈ ds, d < 5) → (∀ d ∈ ds', d < 5) →
    (ds.foldl (fun x d => x * 5 + d) a = ds'.foldl (fun x d => x * 5 + d) a' ↔ a = a' ∧ ds = ds')
  | [], [], a, a', _, _, _ => by simp
  | [], _ :: _, _, _, h, _, _ => by simp at h
  | _ :: _, [], _, _, h, _, _ => by simp at h
  | d :: ds, d' :: ds', a, a', hl, h1, h2 => by
    simp only [List.foldl_cons]
    rw [hc_enc_inj ds ds' (a * 5 + d) (a' * 5 + d') (by simpa using hl)
      (fun x hx => h1 x (List.mem_cons_of_mem _ hx)) (fun x hx => h2 x (List.mem_cons_of_mem _ hx))]
    have hd := h1 d List.mem_cons_self
    have hd' := h2 d' List.mem_cons_self
    simp only [List.cons.injEq]
    constructor
    · rintro ⟨e, e2⟩; exact ⟨by omega, by omega, e2⟩
    · rintro ⟨e, e1, e2⟩; exact ⟨by subst e; subst e1; rfl, e2⟩

/-! ## counting -/

private theorem hc_dc_map {α β γ : Type} [BEq γ] (f : β → γ) (g : α → β) :
    ∀ l : List α, dc f (l.map g) = dc (fun x => f (g x)) l
  | [] => rfl
  | a :: l => by simp [dc, List.any_map, Function.comp_def, hc_dc_map f g l]

private theorem hc_dc_congr {α β γ : Type} [BEq β] [LawfulBEq β] [BEq γ] [LawfulBEq γ] (f : α → β) (g : α → γ)
    (l : List α) (h : ∀ a ∈ l, ∀ b ∈ l, f a = f b ↔ g a = g b) : dc f l = dc g l :=
  Nat.le_antisymm (dc_mono f g l fun a ha b hb e => (h a ha b hb).2 e)
    (dc_mono g f l fun a ha b hb e => (h a ha b hb).1 e)

private theorem hc_H_congr {α β γ δ : Type} [BEq α] [LawfulBEq α] [BEq β] [LawfulBEq β] [BEq γ] [LawfulBEq γ]
    [BEq δ] [LawfulBEq δ] (l : List Nat) (g1 : Nat → α × β) (g2 : Nat → γ × δ)
    (h1 : ∀ t ∈ l, ∀ t' ∈ l, (g1 t).1 = (g1 t').1 ↔ (g2 t).1 = (g2 t').1)
    (h2 : ∀ t ∈ l, ∀ t' ∈ l, (g1 t).2 = (g1 t').2 ↔ (g2 t).2 = (g2 t').2) :
    (l.map g1).map (fun r => dc (fun r' => r'.2) ((l.map g1).filter fun r' => r'.1 == r.1)) =
    (l.map g2).map (fun r => dc (fun r' => r'.2) ((l.map g2).filter fun r' => r'.1 == r.1)) := by
  simp only [List.map_map, List.filter_map]
  apply List.map_congr_left
  intro t ht
  simp only [Function.comp_def, hc_dc_map]
  have hf : l.filter (fun x => (g1 x).1 == (g1 t).1) = l.filter (fun x => (g2 x).1 == (g2 t).1) := by
    apply List.filter_congr
    intro x hx
    rw [Bool.eq_iff_iff, beq_iff_eq, beq_iff_eq]
    exact h1 x hx t ht
  rw [hf]
  apply hc_dc_congr
  intro a ha b hb
  exact h2 a (List.mem_filter.1 ha).1 b (List.mem_filter.1 hb).1

private theorem hc_cnt_foldl (p : Nat) : ∀ (RL : List ((Nat × Nat) × Bool)) (a : Nat),
    RL.foldl (fun a e => if e.2 && e.1.1 == p then a + 1 else a) a = a + cntClass RL p
  | [], a => rfl
  | e :: RL, a => by
    simp only [cntClass, List.foldl_cons] at *
    rw [hc_cnt_foldl p RL, hc_cnt_foldl p RL]
    split <;> omega

private theorem hc_cnt_cons (p : Nat) (e : (Nat × Nat) × Bool) (RL : List ((Nat × Nat) × Bool)) :
    cntClass (e :: RL) p = (if e.2 && e.1.1 == p then 1 else 0) + cntClass RL p := by
  show List.foldl _ (if e.2 && e.1.1 == p then 0 + 1 else 0) RL = _
  rw [hc_cnt_foldl]

private theorem hc_cnt_eq (p : Nat) : ∀ rows : List (Nat × Nat),
    cntClass (rows.zip (lastFlags rows)) p = dc (fun r' => r'.2) (rows.filter fun r' => r'.1 == p)
  | [] => rfl
  | r :: L => by
    have ih := hc_cnt_eq p L
    have e : cntClass ((r :: L).zip (lastFlags (r :: L))) p =
        (if (!L.any (fun r2 => r2.1 == r.1 && r2.2 == r.2)) && r.1 == p then 1 else 0) +
          cntClass (L.zip (lastFlags L)) p := by
      simp only [lastFlags, List.zip_cons_cons]
      rw [hc_cnt_cons]
    rw [e, ih]
    by_cases hr : r.1 = p
    · subst hr
      simp only [List.filter_cons, beq_self_eq_true, if_true, dc, List.any_filter]
      have ha : (L.any fun a => a.1 == r.1 && a.2 == r.2) = (L.any fun r2 => r2.1 == r.1 && r2.2 == r.2) := rfl
      cases h : L.any (fun r2 => r2.1 == r.1 && r2.2 == r.2) <;> simp [h] <;> omega
    · have : (r.1 == p) = false := by simpa using hr
      simp [List.filter_cons, this]

private theorem hc_foldl_max {α : Type} (G : α → Nat) : ∀ (l : List α) (a : Nat),
    l.foldl (fun a r => max a (G r)) a = max a (maxList (l.map G))
  | [], a => by simp [maxList]
  | r :: l, a => by
    simp only [List.foldl_cons, hc_foldl_max G l, List.map_cons, maxList]
    omega

/-! ## lists for the cover search -/

private theorem hc_mem_dd {α : Type} [DecidableEq α] {a : α} : ∀ {l : List α}, a ∈ dd l → a ∈ l
  | [], h => by simp [dd] at h
  | b :: l, h => by
    simp only [dd] at h
    split at h
    · exact List.mem_cons_of_mem _ (hc_mem_dd h)
    · rcases List.mem_cons.1 h with e | e
      · exact e ▸ List.mem_cons_self
      · exact List.mem_cons_of_mem _ (hc_mem_dd e)

private theorem hc_dd_map {α β : Type} [DecidableEq α] [DecidableEq β] (g : α → β) : ∀ l : List α,
    (∀ a ∈ l, ∀ b ∈ l, g a = g b → a = b) → dd (l.map g) = (dd l).map g
  | [], _ => rfl
  | a :: l, h => by
    have ih := hc_dd_map g l (fun x hx y hy => h x (List.mem_cons_of_mem _ hx) y (List.mem_cons_of_mem _ hy))
    have hiff : g a ∈ l.map g ↔ a ∈ l := by
      constructor
      · intro hm
        obtain ⟨b, hb, hgb⟩ := List.mem_map.1 hm
        have := h b (List.mem_cons_of_mem _ hb) a List.mem_cons_self hgb
        exact this ▸ hb
      · exact List.mem_map_of_mem
    simp only [List.map_cons, dd]
    by_cases ha : a ∈ l
    · rw [if_pos (hiff.2 ha), if_pos ha, ih]
    · rw [if_neg (fun hm => ha (hiff.1 hm)), if_neg ha, ih, List.map_cons]

private theorem hc_mem_combs {α : Type} : ∀ (s : Nat) (A F : List α), F ∈ combs s A → ∀ x ∈ F, x ∈ A
  | 0, A, F, h, x, hx => by
    cases A <;> simp [combs] at h <;> subst h <;> simp at hx
  | s + 1, [], F, h, x, hx => by simp [combs] at h
  | s + 1, a :: A, F, h, x, hx => by
    simp only [combs, List.mem_append, List.mem_map] at h
    rcases h with ⟨F', hF', rfl⟩ | h
    · rcases List.mem_cons.1 hx with e | e
      · exact e ▸ List.mem_cons_self
      · exact List.mem_cons_of_mem _ (hc_mem_combs s A F' hF' x e)
    · exact List.mem_cons_of_mem _ (hc_mem_combs (s + 1) A F h x hx)

private theorem hc_coverDFS (full : UInt64) : ∀ (s : Nat) (xs : List UInt64) (acc : UInt64),
    coverDFS full s xs acc = (combs s xs).any (fun F => F.foldl (· ||| ·) acc == full)
  | 0, xs, acc => by cases xs <;> simp [coverDFS, combs]
  | s + 1, [], acc => by simp [coverDFS, combs]
  | s + 1, x :: xs, acc => by
    simp only [coverDFS, combs, List.any_append, List.any_map, Function.comp_def, List.foldl_cons,
      hc_coverDFS full s xs (acc ||| x), hc_coverDFS full (s + 1) xs acc]

private theorem hc_foldl_or_tb (i : Nat) : ∀ (F : List UInt64) (acc : UInt64),
    (F.foldl (· ||| ·) acc).toNat.testBit i = (acc.toNat.testBit i || F.any fun x => x.toNat.testBit i)
  | [], acc => by simp
  | x :: F, acc => by
    simp only [List.foldl_cons, hc_foldl_or_tb i F, hc_or_tb, List.any_cons, Bool.or_assoc]

private theorem hc_mask_tb (f : FC) (hf : FCOK f) (i : Nat) : f.mask.toNat.testBit i = decide (i < f.c.m) := by
  rw [hf.mask]
  have hm := hf.hm
  have h1 : ((1 : UInt64) <<< f.c.m.toUInt64).toNat = 2 ^ f.c.m := by
    rw [UInt64.toNat_shiftLeft, hc_toUInt64 (by omega), Nat.mod_eq_of_lt (show f.c.m < 64 by omega)]
    have : (1 : UInt64).toNat = 1 := rfl
    rw [this, Nat.shiftLeft_eq, Nat.one_mul]
    exact Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (by decide) (by omega))
  have hp1 : 1 ≤ 2 ^ f.c.m := Nat.one_le_two_pow
  have hp2 : 2 ^ f.c.m ≤ 2 ^ 32 := Nat.pow_le_pow_right (by decide) hm
  have h2 : ((1 : UInt64) <<< f.c.m.toUInt64 - 1).toNat = 2 ^ f.c.m - 1 := by
    rw [UInt64.toNat_sub, h1]
    have : (1 : UInt64).toNat = 1 := rfl
    rw [this]
    rw [show 2 ^ 64 - 1 + 2 ^ f.c.m = (2 ^ f.c.m - 1) + 2 ^ 64 by omega, Nat.add_mod_right,
      Nat.mod_eq_of_lt (by omega)]
  rw [h2, Nat.testBit_two_pow_sub_one]

private theorem hc_eq_mask (f : FC) (hf : FCOK f) (x : UInt64) :
    (x == f.mask) = true ↔ ∀ i, x.toNat.testBit i = decide (i < f.c.m) := by
  rw [beq_iff_eq, ← UInt64.toNat_inj]
  constructor
  · intro h i; rw [h, hc_mask_tb f hf]
  · intro h; apply Nat.eq_of_testBit_eq; intro i; rw [h, hc_mask_tb f hf]

/-- The plane test of a cover candidate equals the spec's `coversA` on the decoded columns. -/
private theorem hc_cov (f : FC) (hf : FCOK f) (F : List PCol) (hF : ∀ p ∈ F, WFcol f.c p) {j : Nat}
    (hj : j < f.c.n) :
    ((F.map (·.oh j)).foldl (· ||| ·) 0 == f.mask) = coversA f.c (F.map fun p => (decodeCol f.c p).toArray) j := by
  rw [Bool.eq_iff_iff, hc_eq_mask f hf]
  simp only [hc_foldl_or_tb, UInt64.toNat_zero, Nat.zero_testBit, Bool.false_or, List.any_map,
    Function.comp_def]
  have hoh : ∀ p ∈ F, ∀ i, (p.oh j).toNat.testBit i = decide (i < f.c.m ∧ laneValS f.c.n p i = j) :=
    fun p hp i => hc_oh_wf f.c hf.hm hf.hn4 (hF p hp) hj i
  simp only [coversA, List.all_eq_true, List.mem_range, List.any_map, Function.comp_def, List.any_eq_true,
    cget_toArray]
  constructor
  · intro h i hi
    have := h i
    simp only [hi, decide_true, List.any_eq_true] at this
    obtain ⟨p, hp, hb⟩ := this
    rw [hoh p hp] at hb
    refine ⟨p, hp, ?_⟩
    rw [hc_decodeCol_getD f.c p hi]
    simp at hb
    simp only [beq_iff_eq]
    omega
  · intro h i
    by_cases hi : i < f.c.m
    · obtain ⟨p, hp, hb⟩ := h i hi
      rw [hc_decodeCol_getD f.c p hi] at hb
      simp only [hi, decide_true, List.any_eq_true]
      refine ⟨p, hp, ?_⟩
      rw [hoh p hp]
      have hb' : laneValS f.c.n p i = j := by simp at hb; omega
      simp [hi, hb']
    · simp only [hi, decide_false]
      rw [Bool.eq_false_iff]
      intro hc
      obtain ⟨p, hp, hb⟩ := List.any_eq_true.1 hc
      rw [hoh p hp] at hb
      simp at hb
      exact hi hb.1

/-- Decoding is injective on well-formed columns. -/
private theorem hc_decode_inj (c : Ctx) (hm : c.m ≤ 32) (hn4 : c.n ≤ 4) {p q : PCol} (hp : WFcol c p)
    (hq : WFcol c q) (h : decodeCol c p = decodeCol c q) : p = q := by
  have hl : ∀ t < c.m, laneValS c.n p t = laneValS c.n q t := by
    intro t ht
    have := congrArg (fun l => l.getD t 0) h
    simp only [hc_decodeCol_getD c _ ht] at this
    exact Int.ofNat.inj this
  -- every plane bit is determined by the lane values
  have hpb : ∀ (r : PCol), WFcol c r → ∀ v < 4, ∀ t < 32,
      planeBit r v t = decide (t < c.m ∧ v < c.n ∧ laneValS c.n r t = v) := by
    intro r hr v hv t ht
    obtain ⟨w0, w1, w2, w3⟩ := hc_wf_lane c hr ht
    rw [hc_sel r hv, hc_core_sel c.n (by omega) v hv _ _ _ _ _ w0 w1 w2 w3, hc_laneValS_B]
    generalize lvB c.n _ _ _ _ = L
    by_cases hL : L = v <;> by_cases hv' : v < c.n <;> by_cases ht' : t < c.m <;> simp [hL, hv', ht']
  have hpl : ∀ v < 4, ∀ t < 32, planeBit p v t = planeBit q v t := by
    intro v hv t ht
    rw [hpb p hp v hv t ht, hpb q hq v hv t ht]
    by_cases htm : t < c.m
    · rw [hl t htm]
    · simp [htm]
  have hlo : p.lo = q.lo := by
    rw [← UInt64.toNat_inj]; apply Nat.eq_of_testBit_eq; intro i
    by_cases hi : i < 64
    · by_cases h32 : i < 32
      · have := hpl 0 (by decide) i h32
        simpa [hc_pb0, bitU] using this
      · have := hpl 1 (by decide) (i - 32) (by omega)
        simp only [hc_pb1, bitU] at this
        rwa [show 32 + (i - 32) = i by omega] at this
    · rw [hc_tb_ge64 _ (by omega), hc_tb_ge64 _ (by omega)]
  have hhi : p.hi = q.hi := by
    rw [← UInt64.toNat_inj]; apply Nat.eq_of_testBit_eq; intro i
    by_cases hi : i < 64
    · by_cases h32 : i < 32
      · have := hpl 2 (by decide) i h32
        simpa [hc_pb2, bitU] using this
      · have := hpl 3 (by decide) (i - 32) (by omega)
        simp only [hc_pb3, bitU] at this
        rwa [show 32 + (i - 32) = i by omega] at this
    · rw [hc_tb_ge64 _ (by omega), hc_tb_ge64 _ (by omega)]
  cases p; cases q
  simp only at hlo hhi
  rw [hlo, hhi]

private theorem hc_coverFrom (f : FC) (ms : List UInt64) (A : List (Array Int)) (j : Nat)
    (h : ∀ s, coverDFS f.mask s ms 0 = (combs s A).any (fun F => coversA f.c F j)) :
    ∀ fuel s, coverFromP f ms fuel s = coverFrom f.c A j fuel s
  | 0, s => rfl
  | fuel + 1, s => by
    simp only [coverFromP, coverFrom, h s, hc_coverFrom f ms A j h fuel (s + 1)]

end hcPriv

/-! ## H1 -/

section
variable (f : FC)

/-- `hcP2` equals the spec `hc` when the input indices `f.inv` (for `v ≤ n`) are base-5 digits. -/
theorem hcP2_eq_of_inv5 (hf : FCOK f) (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (k : PKey) : hcP2 f k = hc f.c (decodeK f.c k) := by
  have hm := hf.hm
  let u := undoneP f k
  let D : Nat → PCol → Nat := fun t p => f.inv.getD (t * 8 + laneValS f.c.n p t) 0
  let decF : Nat → Ordering := fun t =>
    if bitU k.fl t then .lt else if bitU k.fl (32 + t) then .gt else .eq
  let g1 : Nat → Nat × Nat := fun t => (sigCode f k t, usCode f u t)
  let g2 : Nat → (Ordering × List Nat) × List Nat := fun i =>
    (stateSigA f.c (decodeK f.c k) ((decodeK f.c k).cols.map List.toArray) i, usig f.c (decodeK f.c k) i)
  have hu : undone f.c (decodeK f.c k) = u := rfl
  -- fast codes
  have hs1 : ∀ t < f.c.m, sigCode f k t =
      (k.cols.map (D t)).foldl (fun x d => x * 5 + d) (if bitU k.fl t then 0 else if bitU k.fl (32 + t) then 2 else 1) := by
    intro t ht
    simp only [sigCode, List.foldl_map, hc_laneFl f k.fl (show t < 32 by omega), D]
    congr 1
    funext a p
    rw [hc_laneVal f hf p (show t < 32 by omega)]
  have hs2 : ∀ t, usCode f u t = (u.map fun j => f.inv.getD (t * 8 + j) 0).foldl (fun x d => x * 5 + d) 0 := by
    intro t
    simp only [usCode, List.foldl_map]
  -- spec rows
  have hg2 : ∀ i < f.c.m, g2 i = ((decF i, k.cols.map (D i)), u.map fun j => f.inv.getD (i * 8 + j) 0) := by
    intro i hi
    simp only [g2]
    rw [stateSigA_eq]
    simp only [stateSig, usig, hu, decodeK, hc_decodeFl_getD f.c k.fl hi, List.map_map]
    simp only [Prod.mk.injEq]
    refine ⟨⟨rfl, ?_⟩, ?_⟩
    · apply List.map_congr_left
      intro p _
      simp only [Function.comp_apply, hc_decodeCol_getD f.c p hi, D]
      rw [hf.inv i hi _ (hc_laneValS_le _ p i)]
    · apply List.map_congr_left
      intro j hj
      have : j < f.c.n := by
        have hj' : j ∈ undoneP f k := hj
        simp only [undoneP, List.mem_filter, List.mem_range] at hj'; exact hj'.1
      rw [hf.inv i hi j (by omega)]
  have hD5 : ∀ t < f.c.m, ∀ d ∈ k.cols.map (D t), d < 5 := by
    intro t ht d hd
    obtain ⟨p, _, rfl⟩ := List.mem_map.1 hd
    exact hinv5 t ht _ (hc_laneValS_le _ p t)
  have hU5 : ∀ t < f.c.m, ∀ d ∈ u.map (fun j => f.inv.getD (t * 8 + j) 0), d < 5 := by
    intro t ht d hd
    obtain ⟨j, hj, rfl⟩ := List.mem_map.1 hd
    have : j < f.c.n := by
      have hj' : j ∈ undoneP f k := hj
      simp only [undoneP, List.mem_filter, List.mem_range] at hj'; exact hj'.1
    exact hinv5 t ht j (by omega)
  have h1 : ∀ t ∈ List.range f.c.m, ∀ t' ∈ List.range f.c.m, (g1 t).1 = (g1 t').1 ↔ (g2 t).1 = (g2 t').1 := by
    intro t ht t' ht'
    rw [List.mem_range] at ht ht'
    rw [hg2 t ht, hg2 t' ht']
    simp only [g1, hs1 t ht, hs1 t' ht']
    rw [hc_enc_inj _ _ _ _ (by simp) (hD5 t ht) (hD5 t' ht'), hc_fl_code]
    simp only [Prod.mk.injEq, decF]
  have h2 : ∀ t ∈ List.range f.c.m, ∀ t' ∈ List.range f.c.m, (g1 t).2 = (g1 t').2 ↔ (g2 t).2 = (g2 t').2 := by
    intro t ht t' ht'
    rw [List.mem_range] at ht ht'
    rw [hg2 t ht, hg2 t' ht']
    simp only [g1, hs2]
    rw [hc_enc_inj _ _ _ _ (by simp) (hU5 t ht) (hU5 t' ht')]
    simp
  have hH := hc_H_congr (List.range f.c.m) g1 g2 h1 h2
  unfold hcP2 hc
  simp only []
  rw [hc_foldl_max]
  simp only [Nat.zero_max]
  congr 1
  rw [← hH]
  congr 1
  apply List.map_congr_left
  intro r _
  exact hc_cnt_eq r.1 _

/-! ## the capped cover bound -/

theorem maxCoverBP_eq (hf : FCOK f) (k : PKey) (hk : ∀ p ∈ k.cols, WFcol f.c p) (b : Nat) :
    maxCoverBP f k b = maxCoverB f.c (decodeK f.c k) b := by
  have hdd : dd (decodeK f.c k).cols = (dd k.cols).map (decodeCol f.c) := by
    simp only [decodeK]
    exact hc_dd_map _ _ fun p hp q hq e => hc_decode_inj f.c hf.hm hf.hn4 (hk p hp) (hk q hq) e
  have hu : undone f.c (decodeK f.c k) = undoneP f k := rfl
  unfold maxCoverBP maxCoverB
  simp only []
  rw [hdd, hu, List.length_map]
  congr 1
  apply List.map_congr_left
  intro j hj
  have hjn : j < f.c.n := by
    simp only [undoneP, List.mem_filter, List.mem_range] at hj; exact hj.1
  apply hc_coverFrom
  intro s
  rw [hc_coverDFS, List.map_map, combs_map, combs_map, List.any_map, List.any_map]
  rw [Bool.eq_iff_iff, List.any_eq_true, List.any_eq_true]
  have hW : ∀ F ∈ combs s (dd k.cols), ∀ p ∈ F, WFcol f.c p := fun F hF p hp =>
    hk p (hc_mem_dd (hc_mem_combs s _ F hF p hp))
  constructor
  · rintro ⟨F, hF, h⟩
    refine ⟨F, hF, ?_⟩
    simp only [Function.comp_def] at h ⊢
    rw [← hc_cov f hf F (hW F hF) hjn]
    exact h
  · rintro ⟨F, hF, h⟩
    refine ⟨F, hF, ?_⟩
    simp only [Function.comp_def] at h ⊢
    rw [hc_cov f hf F (hW F hF) hjn]
    exact h
end

/-! ## `hcP2_eq` without an index bound is false -/

section cex

private def hc_cexC : Ctx := { n := 1, ts := [[7, 7, 7, 7, 7, 0], [0]], m := 2, T := [1, 1], tc := [] }
private def hc_cexF : FC := FC.mk hc_cexC 3 ⟨0, 0⟩ [] #[5, 6, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]
  ((LeanReflect.group hc_cexC).map mkTab) (LeanReflect.group hc_cexC)
private def hc_cexK : PKey := { cols := [⟨3, 0⟩], fl := 1, done := [], gam := 0 }

/-- Counterexample to `hcP2_eq` as first stated: `FCOK` allows a test list with an input index 5, the base-5 row
  codes of two different classes collide, and `hcP2 = 1` while `hc = 0`. -/
theorem hcP2_eq_false :
    ¬ ∀ (f : FC), FCOK f → ∀ k : PKey, WFkey f.c k → hcP2 f k = hc f.c (decodeK f.c k) := by
  intro h
  have hok : FCOK hc_cexF :=
    { hm := by decide
      hn1 := by decide
      hn4 := by decide
      mask := by decide
      tcode := rfl
      tc := rfl
      tcWF := by simp [hc_cexF]
      inv := by decide +kernel
      ptab := rfl
      grp := rfl }
  have hwf : WFkey hc_cexF.c hc_cexK := by
    refine ⟨?_, ?_⟩
    · simp only [hc_cexK, List.mem_singleton, forall_eq]; decide +kernel
    · decide +kernel
  have hne : hcP2 hc_cexF hc_cexK ≠ hc hc_cexF.c (decodeK hc_cexF.c hc_cexK) := by decide +kernel
  exact hne (h hc_cexF hok hc_cexK hwf)

end cex

end LeanReflect.FP
