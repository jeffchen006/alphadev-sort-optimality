import LeanReflect.PlaneDefs
namespace LeanReflect.FP
open SortProof LeanReflect

/-! ## Bits of UInt64 -/

theorem bitU_eq (x : UInt64) (i : Nat) : bitU x i = x.toBitVec.getLsbD i := rfl

@[simp] theorem bitU_and (x y : UInt64) (i : Nat) : bitU (x &&& y) i = (bitU x i && bitU y i) := by
  simp [bitU_eq]
@[simp] theorem bitU_or (x y : UInt64) (i : Nat) : bitU (x ||| y) i = (bitU x i || bitU y i) := by
  simp [bitU_eq]
@[simp] theorem bitU_not (x : UInt64) (i : Nat) : bitU (~~~x) i = (decide (i < 64) && !bitU x i) := by
  simp [bitU_eq]
@[simp] theorem bitU_shr32 (x : UInt64) (i : Nat) : bitU (x >>> 32) i = bitU x (32 + i) := by
  simp [bitU_eq]
@[simp] theorem bitU_shl32 (x : UInt64) (i : Nat) :
    bitU (x <<< 32) i = (decide (32 ≤ i) && decide (i < 64) && bitU x (i - 32)) := by
  simp only [bitU, UInt64.toNat_shiftLeft, Nat.testBit_mod_two_pow, Nat.testBit_shiftLeft]
  have : (32 : UInt64).toNat % 64 = 32 := rfl
  rw [this]; by_cases h1 : 32 ≤ i <;> by_cases h2 : i < 64 <;> simp [h1, h2]
@[simp] theorem bitU_zero (i : Nat) : bitU 0 i = false := by simp [bitU]

theorem bitU_ge (x : UInt64) {i : Nat} (h : 64 ≤ i) : bitU x i = false :=
  Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le x.toNat_lt (Nat.pow_le_pow_right (by decide) h))

@[simp] theorem bitU_M32 (i : Nat) : bitU M32 i = decide (i < 32) := by
  have : M32.toNat = 2 ^ 32 - 1 := rfl
  rw [bitU, this, Nat.testBit_two_pow_sub_one]

theorem bitU_neg_and (x : UInt64) (i : Nat) :
    bitU (x &&& (0 - x)) i = (bitU x i && decide (∀ j < i, bitU x j = false)) := by
  have h0 : (0 - x).toBitVec = - x.toBitVec := by
    simp
  simp only [bitU_eq, UInt64.toBitVec_and, BitVec.getLsbD_and, h0, BitVec.getLsbD_neg]
  cases hx : x.toBitVec.getLsbD i
  · simp
  · simp only [BitVec.lt_of_getLsbD hx, Bool.true_xor, decide_true, Bool.true_and]
    rw [Bool.eq_iff_iff]; simp; exact decide_eq_true_iff.symm

theorem UInt64.ext_bit {x y : UInt64} (h : ∀ i < 64, bitU x i = bitU y i) : x = y := by
  apply UInt64.toBitVec_inj.1
  apply BitVec.eq_of_getLsbD_eq
  intro i hi; exact h i hi

theorem eq_zero_iff_bit (x : UInt64) : x = 0 ↔ ∀ i < 64, bitU x i = false := by
  constructor
  · intro h i _; simp [h]
  · intro h; apply UInt64.ext_bit; intro i hi; simp [h i hi]

theorem ne_zero_iff_bit (x : UInt64) : x ≠ 0 ↔ ∃ i < 64, bitU x i = true := by
  rw [Ne, eq_zero_iff_bit]
  constructor
  · intro h
    apply Classical.byContradiction; intro h'
    exact h (fun i hi => by cases hb : bitU x i <;> simp_all)
  · intro ⟨i, hi, hb⟩ h; simp [h i hi] at hb

theorem bitU_one_shl {t : Nat} (ht : t < 64) (i : Nat) : bitU (1 <<< t.toUInt64) i = decide (i = t) := by
  have : (1 <<< t.toUInt64 : UInt64).toNat = 2 ^ t := by
    simp [Nat.toUInt64_eq, Nat.mod_eq_of_lt (show t < 2^64 by omega), Nat.mod_eq_of_lt ht, Nat.shiftLeft_eq]
    exact Nat.pow_lt_pow_right (by decide) ht
  simp [bitU, this, Nat.testBit_two_pow]; omega

theorem and_one_shl_ne {t : Nat} (ht : t < 64) (x : UInt64) : (x &&& (1 <<< t.toUInt64) != 0) = bitU x t := by
  cases hb : bitU x t
  · simp only [bne_eq_false_iff_eq, eq_zero_iff_bit, bitU_and, bitU_one_shl ht]
    intro i _; by_cases hi : i = t <;> simp_all
  · simp only [bne_iff_ne, ne_eq]
    rw [← Ne, ne_zero_iff_bit]; exact ⟨t, ht, by simp [bitU_one_shl ht, hb]⟩

/-! ## Planes and lanes -/

theorem pb0 (p : PCol) (t : Nat) : planeBit p 0 t = bitU p.lo t := by simp [planeBit]
theorem pb1 (p : PCol) (t : Nat) : planeBit p 1 t = bitU p.lo (32 + t) := by simp [planeBit]
theorem pb2 (p : PCol) (t : Nat) : planeBit p 2 t = bitU p.hi t := by simp [planeBit]
theorem pb3 (p : PCol) (t : Nat) : planeBit p 3 t = bitU p.hi (32 + t) := by simp [planeBit]

theorem laneValS_le (n : Nat) (p : PCol) (t : Nat) : laneValS n p t ≤ n := by
  unfold laneValS; split
  · omega
  split
  · omega
  split
  · omega
  split <;> omega

theorem lane_cases {n : Nat} (h1 : 1 ≤ n) (h4 : n ≤ 4) : n = 1 ∨ n = 2 ∨ n = 3 ∨ n = 4 := by omega

theorem laneValS_pb (n : Nat) (p : PCol) (t : Nat) (h : laneValS n p t < n) :
    planeBit p (laneValS n p t) t = true := by
  simp only [laneValS] at *
  by_cases h0 : 1 ≤ n ∧ planeBit p 0 t = true
  · simp [h0]
  simp only [h0, if_false] at h ⊢
  by_cases h1 : 2 ≤ n ∧ planeBit p 1 t = true
  · simp [h1]
  simp only [h1, if_false] at h ⊢
  by_cases h2 : 3 ≤ n ∧ planeBit p 2 t = true
  · simp [h2]
  simp only [h2, if_false] at h ⊢
  by_cases h3 : 4 ≤ n ∧ planeBit p 3 t = true
  · simp [h3]
  simp only [h3, if_false] at h ⊢
  omega

/-- Well-formed columns: plane bit = (lane in range, value < n, lane value = v). -/
theorem wf_pb {c : Ctx} {p : PCol} (hp : WFcol c p) {v t : Nat} (hv : v < 4) (ht : t < 32) :
    planeBit p v t = (decide (t < c.m) && decide (v < c.n) && laneValS c.n p t == v) := by
  cases hb : planeBit p v t
  · by_cases e : laneValS c.n p t = v
    · by_cases hn : v < c.n
      · have := laneValS_pb c.n p t (e ▸ hn); rw [e, hb] at this; cases this
      · simp [hn]
    · simp [e]
  · obtain ⟨a, b, low⟩ := hp v hv t ht hb
    have : laneValS c.n p t = v := by
      obtain rfl | rfl | rfl | rfl : v = 0 ∨ v = 1 ∨ v = 2 ∨ v = 3 := by omega
      · simp [laneValS, hb, show 1 ≤ c.n by omega]
      · simp [laneValS, hb, show 2 ≤ c.n by omega, low 0 (by decide)]
      · simp [laneValS, hb, show 3 ≤ c.n by omega, low 0 (by decide), low 1 (by decide)]
      · simp [laneValS, hb, show 4 ≤ c.n by omega, low 0 (by decide), low 1 (by decide), low 2 (by decide)]
    simp [a, b, this]

theorem laneValS_zero (n t : Nat) : laneValS n ⟨0, 0⟩ t = n := by simp [laneValS, planeBit]

/-! ## 1. laneVal -/

theorem laneVal_eq {f : FC} (hf : FCOK f) (p : PCol) (t : Nat) (ht : t < 32) : laneVal f p t = laneValS f.c.n p t := by
  have e0 : (p.p0 &&& (1 <<< t.toUInt64) != 0) = planeBit p 0 t := by
    rw [and_one_shl_ne (by omega)]; simp [PCol.p0, pb0, ht]
  have e1 : (p.p1 &&& (1 <<< t.toUInt64) != 0) = planeBit p 1 t := by
    rw [and_one_shl_ne (by omega)]; simp [PCol.p1, pb1]
  have e2 : (p.p2 &&& (1 <<< t.toUInt64) != 0) = planeBit p 2 t := by
    rw [and_one_shl_ne (by omega)]; simp [PCol.p2, pb2, ht]
  have e3 : (p.p3 &&& (1 <<< t.toUInt64) != 0) = planeBit p 3 t := by
    rw [and_one_shl_ne (by omega)]; simp [PCol.p3, pb3]
  simp only [laneVal, e0, e1, e2, e3, laneValS]
  rcases lane_cases hf.hn1 hf.hn4 with h | h | h | h <;> simp [h]

/-! ## mask -/

theorem bitU_mask {f : FC} (hf : FCOK f) (i : Nat) : bitU f.mask i = decide (i < f.c.m) := by
  have hm := hf.hm
  have e1 : ((1 : UInt64) <<< f.c.m.toUInt64).toNat = 2 ^ f.c.m := by
    simp [Nat.toUInt64_eq, Nat.mod_eq_of_lt (show f.c.m < 2^64 by omega),
      Nat.mod_eq_of_lt (show f.c.m < 64 by omega), Nat.shiftLeft_eq]
    show 2 ^ f.c.m < 2 ^ 64
    exact Nat.pow_lt_pow_right (by decide) (by omega)
  have e2 : f.mask.toNat = 2 ^ f.c.m - 1 := by
    rw [hf.mask, UInt64.toNat_sub_of_le, e1]; · rfl
    rw [UInt64.le_iff_toNat_le, e1]; exact Nat.one_le_two_pow
  rw [bitU, e2, Nat.testBit_two_pow_sub_one]

/-! ## 2–3. merge -/

theorem pb_merge {C : UInt64} (hC : ∀ i, 32 ≤ i → bitU C i = false) (d s : PCol) {v t : Nat} (hv : v < 4)
    (ht : t < 32) : planeBit (merge C d s) v t = if bitU C t then planeBit s v t else planeBit d v t := by
  obtain rfl | rfl | rfl | rfl : v = 0 ∨ v = 1 ∨ v = 2 ∨ v = 3 := by omega
  all_goals
    simp only [merge, pb0, pb1, pb2, pb3, bitU_or, bitU_and, bitU_not, bitU_shl32, hC (32 + t) (by omega),
      show ¬ 32 ≤ t by omega, show 32 + t < 64 by omega, show t < 64 by omega, Nat.add_sub_cancel_left]
    cases bitU C t <;> simp

theorem laneValS_merge {C : UInt64} (hC : ∀ i, 32 ≤ i → bitU C i = false) (n : Nat) (d s : PCol) {t : Nat}
    (ht : t < 32) : laneValS n (merge C d s) t = if bitU C t then laneValS n s t else laneValS n d t := by
  simp only [laneValS, pb_merge hC d s (by decide : 0 < 4) ht, pb_merge hC d s (by decide : 1 < 4) ht,
    pb_merge hC d s (by decide : 2 < 4) ht, pb_merge hC d s (by decide : 3 < 4) ht]
  cases bitU C t <;> simp

theorem WF_merge {f : FC} (hf : FCOK f) (C : UInt64) (d s : PCol) (hd : WFcol f.c d) (hs : WFcol f.c s)
    (hC : C.toNat < 2 ^ 32) : WFcol f.c (merge C d s) := by
  have hC' : ∀ i, 32 ≤ i → bitU C i = false := fun i hi =>
    Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le hC (Nat.pow_le_pow_right (by decide) hi))
  intro v hv t ht h
  rw [pb_merge hC' d s hv ht] at h
  cases hb : bitU C t <;> simp only [hb] at h
  · obtain ⟨a, b, e⟩ := hd v hv t ht h
    exact ⟨a, b, fun v' hv' => by rw [pb_merge hC' d s (by omega) ht, hb]; exact e v' hv'⟩
  · obtain ⟨a, b, e⟩ := hs v hv t ht h
    exact ⟨a, b, fun v' hv' => by rw [pb_merge hC' d s (by omega) ht, hb]; exact e v' hv'⟩

theorem condMask_hi {f : FC} (hf : FCOK f) (cd : Cond) (fl : UInt64) : ∀ i, 32 ≤ i → bitU (condMask f cd fl) i = false := by
  intro i hi
  have hm := hf.hm
  cases cd <;> simp [condMask, bitU_mask hf, bitU_ge fl (show 64 ≤ 32 + i by omega)] <;> omega

theorem condMask_lt {f : FC} (hf : FCOK f) (cd : Cond) (fl : UInt64) : (condMask f cd fl).toNat < 2 ^ 32 :=
  Nat.lt_pow_two_of_testBit _ (condMask_hi hf cd fl)

theorem WF_merge_cond {f : FC} (hf : FCOK f) (cd : Cond) (fl : UInt64) (d s : PCol) (hd : WFcol f.c d)
    (hs : WFcol f.c s) : WFcol f.c (merge (condMask f cd fl) d s) :=
  WF_merge hf _ d s hd hs (condMask_lt hf cd fl)

/-- Lane entry of decoded flags. -/
def flE (fl : UInt64) (t : Nat) : Ordering := if bitU fl t then .lt else if bitU fl (32 + t) then .gt else .eq

theorem decodeFl_eq (c : Ctx) (fl : UInt64) : decodeFl c fl = (List.range c.m).map (flE fl) := rfl

theorem condMask_bit {f : FC} (hf : FCOK f) (cd : Cond) (fl : UInt64) (hfl : WFfl f.c fl) {t : Nat}
    (ht : t < f.c.m) : bitU (condMask f cd fl) t = cd.eval (flE fl t) := by
  have ht32 : t < 32 := Nat.lt_of_lt_of_le ht hf.hm
  have h := (hfl t ht32).1
  cases cd <;> cases h1 : bitU fl t <;> cases h2 : bitU fl (32 + t) <;>
    simp_all [condMask, flE, Cond.eval, bitU_mask hf, show t < 64 by omega]

theorem merge_map {α : Type} (cd : Cond) (L : List α) (g : α → Ordering) (a b : α → Int) :
    LeanReflect.merge cd (L.map g) (L.map a) (L.map b) = L.map fun t => if cd.eval (g t) then b t else a t := by
  induction L with
  | nil => rfl
  | cons x L ih => simp [LeanReflect.merge, ih]

theorem decode_merge {f : FC} (hf : FCOK f) (cd : Cond) (fl : UInt64) (hfl : WFfl f.c fl) (d s : PCol) :
    decodeCol f.c (merge (condMask f cd fl) d s) =
      LeanReflect.merge cd (decodeFl f.c fl) (decodeCol f.c d) (decodeCol f.c s) := by
  simp only [decodeCol, decodeFl_eq, merge_map]
  apply List.map_congr_left
  intro t ht
  have ht' := List.mem_range.1 ht
  rw [laneValS_merge (condMask_hi hf cd fl) _ d s (Nat.lt_of_lt_of_le ht' hf.hm), condMask_bit hf cd fl hfl ht']
  split <;> rfl

/-- `WF_merge` as first stated (any `C`) is false: the high half of `C` selects planes 1 and 3 on its own,
  so a lane can get plane 0 from `d` and plane 1 from `s`. -/
def cexC : Ctx := ⟨2, [], 1, [2], [[0], [1]]⟩
def cexF : FC :=
  { c := cexC, mask := 1, tcode := ⟨0, 0⟩, tc := [⟨1, 0⟩, ⟨0x100000000, 0⟩], inv := #[]
    ptab := (group cexC).map mkTab, grp := group cexC }

theorem cexF_ok : FCOK cexF where
  hm := by decide
  hn1 := by decide
  hn4 := by decide
  mask := by decide
  tcode := rfl
  tc := by decide
  tcWF := by decide
  inv := by decide
  ptab := rfl
  grp := rfl

theorem WF_merge_unbounded_false :
    ¬ ∀ (f : FC), FCOK f → ∀ (C : UInt64) (d s : PCol), WFcol f.c d → WFcol f.c s → WFcol f.c (merge C d s) := by
  intro h
  have := h cexF cexF_ok 0x100000000 ⟨1, 0⟩ ⟨0x100000000, 0⟩ (by decide) (by decide)
  revert this; decide

/-! ## 4–5. one-hot planes, ltMask, cmpFl -/

/-- Least plane with bit t (4 if none). -/
def ohv (p : PCol) (t : Nat) : Nat :=
  if planeBit p 0 t then 0 else if planeBit p 1 t then 1 else if planeBit p 2 t then 2 else
  if planeBit p 3 t then 3 else 4

theorem ohv_le (p : PCol) (t : Nat) : ohv p t ≤ 4 := by
  unfold ohv; split <;> (try split) <;> (try split) <;> (try split) <;> omega

theorem bitU_oh (p : PCol) {j : Nat} (hj : j < 4) (t : Nat) : bitU (p.oh j) t = (decide (t < 32) && ohv p t == j) := by
  by_cases ht : t < 32
  · obtain rfl | rfl | rfl | rfl : j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 := by omega
    all_goals
      simp only [PCol.oh, PCol.p0, PCol.p1, PCol.p2, PCol.p3, bitU_and, bitU_or, bitU_not, bitU_M32, bitU_shr32,
        ohv, pb0, pb1, pb2, pb3, ht, decide_true, show t < 64 by omega, Bool.true_and, Bool.and_true]
      cases bitU p.lo t <;> cases bitU p.lo (32 + t) <;> cases bitU p.hi t <;> cases bitU p.hi (32 + t) <;> simp
  · have h1 := bitU_ge p.lo (show 64 ≤ 32 + t by omega)
    have h2 := bitU_ge p.hi (show 64 ≤ 32 + t by omega)
    obtain rfl | rfl | rfl | rfl : j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 := by omega
    all_goals simp [PCol.oh, PCol.p0, PCol.p1, PCol.p2, PCol.p3, ht, h1, h2]

theorem bitU_ltMask {f : FC} (hf : FCOK f) (a b : PCol) (t : Nat) :
    bitU (ltMask f a b) t = (decide (t < f.c.m) && decide (ohv a t < ohv b t)) := by
  have hm := hf.hm
  simp only [ltMask, bitU_or, bitU_and, bitU_not, bitU_oh _ (show 0 < 4 by decide), bitU_oh _ (show 1 < 4 by decide),
    bitU_oh _ (show 2 < 4 by decide), bitU_oh _ (show 3 < 4 by decide), bitU_mask hf]
  by_cases ht : t < 32
  · have ha := ohv_le a t
    have hb := ohv_le b t
    generalize ohv a t = x at *
    generalize ohv b t = y at *
    simp only [ht, show t < 64 by omega, decide_true, Bool.true_and]
    rcases (show x = 0 ∨ x = 1 ∨ x = 2 ∨ x = 3 ∨ x = 4 by omega) with rfl | rfl | rfl | rfl | rfl <;>
    rcases (show y = 0 ∨ y = 1 ∨ y = 2 ∨ y = 3 ∨ y = 4 by omega) with rfl | rfl | rfl | rfl | rfl <;> simp
  · simp [ht, show ¬ t < f.c.m by omega]

theorem lane_out {c : Ctx} {p : PCol} (hp : WFcol c p) (hn : c.n ≤ 4) {t : Nat} (ht : t < 32) (hm : ¬ t < c.m) :
    laneValS c.n p t = c.n := by
  have hle := laneValS_le c.n p t
  apply Classical.byContradiction; intro hne
  have hlt : laneValS c.n p t < c.n := by omega
  have h1 := laneValS_pb c.n p t hlt
  have h4 : laneValS c.n p t < 4 := by omega
  rw [wf_pb hp h4 ht] at h1; simp [hm] at h1

theorem ohv_wf {c : Ctx} {p : PCol} (hp : WFcol c p) (hn : c.n ≤ 4) {t : Nat} (ht : t < 32) :
    ohv p t = if laneValS c.n p t < c.n then laneValS c.n p t else 4 := by
  simp only [ohv, wf_pb hp (show 0 < 4 by decide) ht, wf_pb hp (show 1 < 4 by decide) ht,
    wf_pb hp (show 2 < 4 by decide) ht, wf_pb hp (show 3 < 4 by decide) ht]
  by_cases hm : t < c.m
  · have hle := laneValS_le c.n p t
    generalize laneValS c.n p t = L at *
    simp only [hm, decide_true, Bool.true_and]
    rcases (show L = 0 ∨ L = 1 ∨ L = 2 ∨ L = 3 ∨ L = 4 by omega) with rfl | rfl | rfl | rfl | rfl <;>
      by_cases h1 : 0 < c.n <;> by_cases h2 : 1 < c.n <;> by_cases h3 : 2 < c.n <;> by_cases h4 : 3 < c.n <;>
        simp [h1, h2, h3, h4] <;> omega
  · simp [hm, lane_out hp hn ht hm]

theorem ohv_lt {c : Ctx} {a b : PCol} (ha : WFcol c a) (hb : WFcol c b) (hn : c.n ≤ 4) {t : Nat} (ht : t < 32) :
    decide (ohv a t < ohv b t) = decide (laneValS c.n a t < laneValS c.n b t) := by
  rw [ohv_wf ha hn ht, ohv_wf hb hn ht]
  have := laneValS_le c.n a t; have := laneValS_le c.n b t
  split <;> split <;> simp <;> omega

theorem cmpFl_lo {f : FC} (hf : FCOK f) (a b : PCol) {t : Nat} (ht : t < 32) :
    bitU (cmpFl f a b) t = (decide (t < f.c.m) && decide (ohv a t < ohv b t)) := by
  simp [cmpFl, bitU_ltMask hf, show ¬ 32 ≤ t by omega]

theorem cmpFl_hi {f : FC} (hf : FCOK f) (a b : PCol) {t : Nat} (ht : t < 32) :
    bitU (cmpFl f a b) (32 + t) = (decide (t < f.c.m) && decide (ohv b t < ohv a t)) := by
  have hm := hf.hm
  simp [cmpFl, bitU_ltMask hf, show ¬ 32 + t < f.c.m by omega, show 32 + t < 64 by omega]

theorem WF_cmpFl {f : FC} (hf : FCOK f) (a b : PCol) : WFfl f.c (cmpFl f a b) := by
  intro t ht
  rw [cmpFl_lo hf a b ht, cmpFl_hi hf a b ht]
  constructor
  · intro h; simp at h; simp [h.1]; omega
  · intro h; simp at h; exact h.1

theorem compare_nat_int (a b : Nat) :
    compare (a : Int) (b : Int) = if a < b then .lt else if b < a then .gt else .eq := by
  split
  · rw [Int.compare_eq_lt]; omega
  split
  · rw [Int.compare_eq_gt]; omega
  · rw [Int.compare_eq_eq]; omega

theorem cmpCol_map {α : Type} (L : List α) (g h : α → Int) :
    cmpCol (L.map g) (L.map h) = L.map fun t => compare (g t) (h t) := by
  induction L with
  | nil => rfl
  | cons x L ih => simp [cmpCol, ih]

theorem decode_cmpFl {f : FC} (hf : FCOK f) (a b : PCol) (ha : WFcol f.c a) (hb : WFcol f.c b) :
    decodeFl f.c (cmpFl f a b) = cmpCol (decodeCol f.c a) (decodeCol f.c b) := by
  simp only [decodeFl_eq, decodeCol, cmpCol_map]
  apply List.map_congr_left
  intro t ht
  have ht' := List.mem_range.1 ht
  have ht32 : t < 32 := Nat.lt_of_lt_of_le ht' hf.hm
  simp only [flE, cmpFl_lo hf a b ht32, cmpFl_hi hf a b ht32, ohv_lt ha hb hf.hn4 ht32, ohv_lt hb ha hf.hn4 ht32,
    compare_nat_int, ht', decide_true, Bool.true_and]
  by_cases h1 : laneValS f.c.n a t < laneValS f.c.n b t <;> simp [h1]

/-! ## 6. canonF -/

theorem wffl_lo {c : Ctx} {fl : UInt64} (h : WFfl c fl) {t : Nat} (ht : t < 32) (hb : bitU fl t = true) :
    t < c.m ∧ bitU fl (32 + t) = false := (h t ht).1 hb

theorem wffl_hi {c : Ctx} {fl : UInt64} (h : WFfl c fl) {t : Nat} (ht : t < 32) (hb : bitU fl (32 + t) = true) :
    t < c.m := (h t ht).2 hb

theorem wffl_lo_out {c : Ctx} {fl : UInt64} (h : WFfl c fl) {t : Nat} (h32 : t < 32) (ht : ¬ t < c.m) :
    bitU fl t = false := by
  cases hb : bitU fl t
  · rfl
  · exact absurd (wffl_lo h h32 hb).1 ht

theorem wffl_hi_out {c : Ctx} {fl : UInt64} (h : WFfl c fl) (hm : c.m ≤ 32) {t : Nat} (ht : ¬ t < c.m) :
    bitU fl (32 + t) = false := by
  by_cases h32 : t < 32
  · cases hb : bitU fl (32 + t)
    · rfl
    · exact absurd (wffl_hi h h32 hb) ht
  · exact bitU_ge fl (by omega)

/-- Swap lt and gt halves. -/
def swF (fl : UInt64) : UInt64 := (fl >>> 32) ||| ((fl &&& M32) <<< 32)

theorem swF_lo (fl : UInt64) {t : Nat} (ht : t < 32) : bitU (swF fl) t = bitU fl (32 + t) := by
  simp [swF, show ¬ 32 ≤ t by omega]
theorem swF_hi (fl : UInt64) {t : Nat} (ht : t < 32) : bitU (swF fl) (32 + t) = bitU fl t := by
  simp [swF, show 32 + t < 64 by omega, bitU_ge fl (show 64 ≤ 32 + (32 + t) by omega), ht]

theorem WF_swF {c : Ctx} {fl : UInt64} (h : WFfl c fl) : WFfl c (swF fl) := by
  intro t ht
  rw [swF_lo fl ht, swF_hi fl ht]
  refine ⟨fun hb => ⟨wffl_hi h ht hb, ?_⟩, fun hb => (wffl_lo h ht hb).1⟩
  cases hb' : bitU fl t
  · rfl
  · rw [(wffl_lo h ht hb').2] at hb; cases hb

theorem decode_swF {c : Ctx} (hm : c.m ≤ 32) {fl : UInt64} (h : WFfl c fl) :
    decodeFl c (swF fl) = (decodeFl c fl).map Ordering.swap := by
  simp only [decodeFl_eq, List.map_map]
  apply List.map_congr_left
  intro t ht
  have ht32 : t < 32 := Nat.lt_of_lt_of_le (List.mem_range.1 ht) hm
  simp only [flE, swF_lo fl ht32, swF_hi fl ht32, Function.comp]
  cases h1 : bitU fl t <;> cases h2 : bitU fl (32 + t) <;> simp [Ordering.swap]
  rw [(wffl_lo h ht32 h1).2] at h2; cases h2

theorem canonF_spec (L : List Ordering) :
    LeanReflect.canonF L = if L.find? (· != .eq) = some .gt then L.map Ordering.swap else L := by
  unfold LeanReflect.canonF
  split <;> simp_all

theorem find_gt_iff {c : Ctx} (hm : c.m ≤ 32) {fl : UInt64} (h : WFfl c fl) :
    (decodeFl c fl).find? (· != .eq) = some .gt ↔
      ∃ i < 64, bitU fl (32 + i) = true ∧ ∀ j < i, (bitU fl j || bitU fl (32 + j)) = false := by
  rw [List.find?_eq_some_iff_getElem]
  simp only [decodeFl_eq, List.getElem_map, List.getElem_range, List.length_map, List.length_range]
  constructor
  · rintro ⟨_, i, hi, he, hlow⟩
    have hi32 : i < 32 := by omega
    refine ⟨i, by omega, ?_, ?_⟩
    · simp only [flE] at he; split at he
      · cases he
      · split at he <;> simp_all
    · intro j hj
      have := hlow j hj
      simp only [flE] at this
      split at this
      · simp at this
      · split at this <;> simp_all
  · rintro ⟨i, hi, hb, hlow⟩
    have hi32 : i < 32 := by
      apply Classical.byContradiction; intro h'; rw [bitU_ge fl (by omega)] at hb; cases hb
    have him := wffl_hi h hi32 hb
    have hl : bitU fl i = false := by
      cases e : bitU fl i
      · rfl
      · rw [(wffl_lo h hi32 e).2] at hb; cases hb
    refine ⟨rfl, i, him, ?_, ?_⟩
    · simp [flE, hl, hb]
    · intro j hj
      have := hlow j hj
      simp at this
      simp [flE, this.1, this.2]

theorem WF_canonF {f : FC} (hf : FCOK f) (fl : UInt64) (h : WFfl f.c fl) : WFfl f.c (canonF fl) := by
  unfold canonF
  simp only
  split
  · exact h
  split
  · exact WF_swF h
  · exact h

theorem decode_canonF {f : FC} (hf : FCOK f) (fl : UInt64) (h : WFfl f.c fl) :
    decodeFl f.c (canonF fl) = LeanReflect.canonF (decodeFl f.c fl) := by
  have hm := hf.hm
  rw [canonF_spec]
  -- the selection bit
  have key : ((fl &&& M32 ||| fl >>> 32 != 0) &&
      ((fl >>> 32) &&& ((fl &&& M32 ||| fl >>> 32) &&& ((0 : UInt64) - (fl &&& M32 ||| fl >>> 32))) != 0)) =
      decide ((decodeFl f.c fl).find? (· != .eq) = some .gt) := by
    rw [Bool.eq_iff_iff, decide_eq_true_iff, find_gt_iff hm h]
    simp only [Bool.and_eq_true, bne_iff_ne, ne_eq]
    rw [← ne_eq, ← ne_eq, ne_zero_iff_bit, ne_zero_iff_bit]
    simp only [bitU_and (fl >>> 32), bitU_neg_and]
    simp only [bitU_and, bitU_or, bitU_M32, bitU_shr32, Bool.and_eq_true, decide_eq_true_iff]
    constructor
    · rintro ⟨_, i, hi, hg, hb, hlow⟩
      have hi32 : i < 32 := by
        apply Classical.byContradiction; intro h'; rw [bitU_ge fl (by omega)] at hg; cases hg
      refine ⟨i, hi, hg, fun j hj => ?_⟩
      have := hlow j hj
      have hj32 : j < 32 := by omega
      simp only [Bool.or_eq_false_iff, Bool.and_eq_false_iff] at this ⊢
      simp_all
    · rintro ⟨i, hi, hg, hlow⟩
      refine ⟨⟨i, hi, by simp [hg]⟩, i, hi, hg, by simp [hg], fun j hj => ?_⟩
      have := hlow j hj
      simp only [Bool.or_eq_false_iff] at this
      simp [this.1, this.2]
  unfold canonF
  simp only
  split
  · rename_i hx
    have hn : ¬ (decodeFl f.c fl).find? (· != .eq) = some .gt := by
      intro hc
      have k2 := key
      rw [bne, hx] at k2
      simp only [Bool.not_true, Bool.false_and] at k2
      rw [eq_comm, decide_eq_false_iff_not] at k2
      exact k2 hc
    rw [if_neg hn]
  · rename_i hx
    split
    · rename_i hg
      have hc : (decodeFl f.c fl).find? (· != .eq) = some .gt := by
        have k2 := key
        rw [bne, Bool.eq_false_iff.2 hx, hg] at k2
        simp only [Bool.not_false, Bool.true_and] at k2
        exact of_decide_eq_true k2.symm
      rw [if_pos hc]
      exact decode_swF hm h
    · rename_i hg
      have hn : ¬ (decodeFl f.c fl).find? (· != .eq) = some .gt := by
        intro hc
        have k2 := key
        rw [bne, Bool.eq_false_iff.2 hx] at k2
        simp only [Bool.eq_false_iff.2 hg, Bool.not_false, Bool.true_and, Bool.and_false] at k2
        rw [eq_comm, decide_eq_false_iff_not] at k2
        exact k2 hc
      rw [if_neg hn]

/-! ## 7. permutations -/

theorem foldl_or_bit (L : List (Nat × Nat)) (a i : Nat) :
    (L.foldl (fun acc (x : Nat × Nat) => match x with | (_, t) => acc ||| 2 ^ t) a).testBit i =
      (a.testBit i || L.any (fun x => x.2 == i)) := by
  induction L generalizing a with
  | nil => simp
  | cons x L ih =>
    obtain ⟨o, t⟩ := x
    simp only [List.foldl, ih, Nat.testBit_or, Nat.testBit_two_pow, List.any_cons]
    cases a.testBit i <;> by_cases h : t = i <;> simp [h]

theorem tabEntry_bit (π : List Nat) (e i : Nat) :
    (tabEntry π e).testBit i =
      decide (∃ ob, π[i]? = some ob ∧ ob / 8 = e / 256 ∧ (e % 256).testBit (ob % 8) = true) := by
  unfold tabEntry
  rw [foldl_or_bit, List.any_filter]
  rw [Bool.eq_iff_iff]
  simp only [Nat.zero_testBit, Bool.false_or, List.any_eq_true, Bool.and_eq_true, beq_iff_eq,
    decide_eq_true_iff]
  constructor
  · rintro ⟨⟨ob, t⟩, hm, ⟨h1, h2⟩, rfl⟩
    rw [List.mem_zipIdx_iff_getElem?] at hm
    exact ⟨ob, hm, h1, h2⟩
  · rintro ⟨ob, hm, h1, h2⟩
    exact ⟨(ob, i), List.mem_zipIdx_iff_getElem?.2 hm, ⟨by simpa using h1, h2⟩, rfl⟩

theorem mkTab_getD (π : List Nat) {e : Nat} (he : e < 1024) : (mkTab π).getD e 0 = tabEntry π e := by
  simp [mkTab, Array.getD, he]

theorem slot (x k y e : Nat) (hy : y < 256) (he : e = 256 * k + y)
    (hyb : ∀ j, y.testBit j = (decide (j < 8) && x.testBit (8 * k + j))) (ob : Nat) :
    (ob / 8 = e / 256 ∧ (e % 256).testBit (ob % 8) = true) ↔ (ob / 8 = k ∧ x.testBit ob = true) := by
  rw [show e / 256 = k by omega, show e % 256 = y by omega, hyb]
  simp only [Bool.and_eq_true, decide_eq_true_iff]
  constructor
  · rintro ⟨h1, _, h3⟩; refine ⟨h1, ?_⟩; rwa [show 8 * k + ob % 8 = ob by omega] at h3
  · rintro ⟨h1, h3⟩; refine ⟨h1, Nat.mod_lt _ (by decide), ?_⟩; rwa [show 8 * k + ob % 8 = ob by omega]

theorem byte_bit (x s : UInt64) (k : Nat) (hs : s.toNat % 64 = 8 * k) (j : Nat) :
    ((x >>> s) &&& 255).toNat.testBit j = (decide (j < 8) && x.toNat.testBit (8 * k + j)) := by
  rw [UInt64.toNat_and, UInt64.toNat_shiftRight, hs, show (255 : UInt64).toNat = 2 ^ 8 - 1 from rfl,
    Nat.testBit_and, Nat.testBit_shiftRight, Nat.testBit_two_pow_sub_one, Bool.and_comm]

theorem byte0_bit (x : UInt64) (j : Nat) :
    (x &&& 255).toNat.testBit j = (decide (j < 8) && x.toNat.testBit (8 * 0 + j)) := by
  rw [UInt64.toNat_and, show (255 : UInt64).toNat = 2 ^ 8 - 1 from rfl,
    Nat.testBit_and, Nat.testBit_two_pow_sub_one, Bool.and_comm, Nat.mul_zero, Nat.zero_add]

theorem byte_lt (x : UInt64) : (x &&& 255).toNat < 256 := by
  rw [UInt64.toNat_and]; exact Nat.lt_of_le_of_lt Nat.and_le_right (by decide)

section perm
variable {f : FC} {π : List Nat}

theorem perm_len (hπ : π.Perm (List.range f.c.m)) : π.length = f.c.m := by
  rw [hπ.length_eq, List.length_range]

theorem perm_lt (hπ : π.Perm (List.range f.c.m)) {t : Nat} (ht : t < f.c.m) : π.getD t 0 < f.c.m := by
  have hl := perm_len hπ
  have : π.getD t 0 = π[t]'(by omega) := by simp [List.getD_eq_getElem?_getD, show t < π.length by omega]
  rw [this]; exact List.mem_range.1 (hπ.subset (List.getElem_mem _))

theorem perm_map {β : Type} (hπ : π.Perm (List.range f.c.m)) (g : Nat → β) :
    π.map g = (List.range f.c.m).map fun t => g (π.getD t 0) := by
  have hl := perm_len hπ
  apply List.ext_getElem (by simp [hl])
  intro t h1 h2
  simp [List.getD_eq_getElem?_getD, show t < π.length by simpa using h1]

theorem permMask_bit' (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (x : UInt64)
    (t : Nat) : bitU (permMask (mkTab π) x) t = (t < f.c.m && bitU x (π.getD t 0)) := by
  have hm := hf.hm
  have hl := perm_len hπ
  have b0 := byte_lt x
  have b1 := byte_lt (x >>> 8)
  have b2 := byte_lt (x >>> 16)
  have b3 := byte_lt (x >>> 24)
  have s0 := slot x.toNat 0 _ ((x &&& 255).toNat) b0 (by omega) (byte0_bit x)
  have s1 := slot x.toNat 1 _ (256 + ((x >>> 8) &&& 255).toNat) b1 (by omega) (byte_bit x 8 1 rfl)
  have s2 := slot x.toNat 2 _ (512 + ((x >>> 16) &&& 255).toNat) b2 (by omega) (byte_bit x 16 2 rfl)
  have s3 := slot x.toNat 3 _ (768 + ((x >>> 24) &&& 255).toNat) b3 (by omega) (byte_bit x 24 3 rfl)
  unfold permMask
  rw [bitU, Nat.toUInt64_eq, UInt64.toNat_ofNat', Nat.testBit_mod_two_pow]
  rw [mkTab_getD π (by omega), mkTab_getD π (by omega), mkTab_getD π (by omega), mkTab_getD π (by omega)]
  simp only [Nat.testBit_or, tabEntry_bit, s0, s1, s2, s3]
  by_cases ht : t < π.length
  · have hob : π[t] < f.c.m := List.mem_range.1 (hπ.subset (List.getElem_mem _))
    simp only [List.getElem?_eq_getElem ht, Option.some.injEq, exists_eq_left', List.getD_eq_getElem?_getD,
      Option.getD_some, bitU, show t < 64 by omega, show t < f.c.m by omega, decide_true, Bool.true_and]
    cases x.toNat.testBit π[t] <;> simp <;> omega
  · simp [List.getElem?_eq_none (show π.length ≤ t by omega), show ¬ t < f.c.m by omega]

theorem permMask_bit (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (x : UInt64) (_hx : x.toNat < 2 ^ 32)
    (t : Nat) : bitU (permMask (mkTab π) x) t = (t < f.c.m && bitU x (π.getD t 0)) :=
  permMask_bit' hf hπ x t

theorem permMask_hi (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (x : UInt64) {t : Nat} (ht : 32 ≤ t) :
    bitU (permMask (mkTab π) x) t = false := by
  have hm := hf.hm
  rw [permMask_bit' hf hπ]; simp; omega

theorem pb_perm (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (p : PCol) {v t : Nat} (hv : v < 4) (ht : t < 32) :
    planeBit (permCol (mkTab π) p) v t = (decide (t < f.c.m) && planeBit p v (π.getD t 0)) := by
  have hm := hf.hm
  by_cases htm : t < f.c.m
  · have hp := perm_lt hπ htm
    obtain rfl | rfl | rfl | rfl : v = 0 ∨ v = 1 ∨ v = 2 ∨ v = 3 := by omega
    all_goals
      simp only [permCol, pb0, pb1, pb2, pb3, bitU_or, bitU_shl32, permMask_bit' hf hπ, PCol.p0, PCol.p1,
        PCol.p2, PCol.p3, bitU_and, bitU_M32, bitU_shr32, htm, decide_true, Bool.true_and,
        show ¬ 32 ≤ t by omega, show ¬ 32 + t < f.c.m by omega, show 32 ≤ 32 + t by omega,
        show 32 + t < 64 by omega, Nat.add_sub_cancel_left, show π.getD t 0 < 32 by omega]
      simp
  · obtain rfl | rfl | rfl | rfl : v = 0 ∨ v = 1 ∨ v = 2 ∨ v = 3 := by omega
    all_goals
      simp only [permCol, pb0, pb1, pb2, pb3, bitU_or, bitU_shl32, permMask_bit' hf hπ, htm, decide_false,
        Bool.false_and, show ¬ 32 ≤ t by omega, show ¬ 32 + t < f.c.m by omega, show 32 ≤ 32 + t by omega,
        show 32 + t < 64 by omega, Nat.add_sub_cancel_left]
      simp

theorem WF_permCol (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (p : PCol) (hp : WFcol f.c p) :
    WFcol f.c (permCol (mkTab π) p) := by
  intro v hv t ht h
  rw [pb_perm hf hπ p hv ht] at h
  simp only [Bool.and_eq_true, decide_eq_true_iff] at h
  have hpt := perm_lt hπ h.1
  obtain ⟨_, b, low⟩ := hp v hv _ (by have := hf.hm; omega) h.2
  exact ⟨h.1, b, fun v' hv' => by rw [pb_perm hf hπ p (by omega) ht, low v' hv']; simp⟩

theorem laneValS_perm (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (p : PCol) {t : Nat} (ht : t < f.c.m) :
    laneValS f.c.n (permCol (mkTab π) p) t = laneValS f.c.n p (π.getD t 0) := by
  have ht32 : t < 32 := by have := hf.hm; omega
  simp only [laneValS, pb_perm hf hπ p (show 0 < 4 by decide) ht32, pb_perm hf hπ p (show 1 < 4 by decide) ht32,
    pb_perm hf hπ p (show 2 < 4 by decide) ht32, pb_perm hf hπ p (show 3 < 4 by decide) ht32, ht, decide_true,
    Bool.true_and]

theorem getD_range_map {β : Type} (m : Nat) (g : Nat → β) (d : β) {t : Nat} (ht : t < m) :
    ((List.range m).map g).getD t d = g t := by
  simp [List.getD_eq_getElem?_getD, ht]

theorem cget_toArray' (l : List Int) (i : Nat) : cget l.toArray i = l.getD i 0 := by
  simp [cget, Array.getD, List.getD_eq_getElem?_getD]
  split <;> simp_all

theorem decode_permCol (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (p : PCol) (hp : WFcol f.c p) :
    decodeCol f.c (permCol (mkTab π) p) = LeanReflect.permCol π (decodeCol f.c p) := by
  have _ := hp
  simp only [LeanReflect.permCol, cget_toArray', perm_map hπ, decodeCol]
  apply List.map_congr_left
  intro t ht
  have ht' := List.mem_range.1 ht
  rw [getD_range_map _ _ _ (perm_lt hπ ht'), laneValS_perm hf hπ p ht']

theorem permFl_lo (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (fl : UInt64) {t : Nat} (ht : t < 32) :
    bitU (permFl (mkTab π) fl) t = (decide (t < f.c.m) && bitU fl (π.getD t 0)) := by
  have hm := hf.hm
  simp only [permFl, bitU_or, bitU_shl32, permMask_bit' hf hπ, bitU_and, bitU_M32, show ¬ 32 ≤ t by omega,
    decide_false, Bool.false_and, Bool.or_false]
  by_cases htm : t < f.c.m
  · simp only [htm, decide_true, Bool.true_and, show π.getD t 0 < 32 by have := perm_lt hπ htm; omega,
      Bool.and_true]
  · simp [htm]

theorem permFl_hi (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (fl : UInt64) {t : Nat} (ht : t < 32) :
    bitU (permFl (mkTab π) fl) (32 + t) = (decide (t < f.c.m) && bitU fl (32 + π.getD t 0)) := by
  have hm := hf.hm
  simp only [permFl, bitU_or, bitU_shl32, permMask_bit' hf hπ, bitU_shr32, show ¬ 32 + t < f.c.m by omega,
    show 32 ≤ 32 + t by omega, show 32 + t < 64 by omega, Nat.add_sub_cancel_left]
  simp

theorem WF_permFl (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (fl : UInt64) (h : WFfl f.c fl) :
    WFfl f.c (permFl (mkTab π) fl) := by
  intro t ht
  rw [permFl_lo hf hπ fl ht, permFl_hi hf hπ fl ht]
  simp only [Bool.and_eq_true, decide_eq_true_iff]
  refine ⟨fun hb => ⟨hb.1, ?_⟩, fun hb => hb.1⟩
  have hpt : π.getD t 0 < 32 := by have := perm_lt hπ hb.1; have := hf.hm; omega
  simp only [(wffl_lo h hpt hb.2).2, Bool.and_false]

theorem decode_permFl (hf : FCOK f) (hπ : π.Perm (List.range f.c.m)) (fl : UInt64) (h : WFfl f.c fl) :
    decodeFl f.c (permFl (mkTab π) fl) = permF π (decodeFl f.c fl) := by
  have _ := h
  simp only [permF, perm_map hπ, decodeFl_eq]
  apply List.map_congr_left
  intro t ht
  have ht' := List.mem_range.1 ht
  have ht32 : t < 32 := by have := hf.hm; omega
  rw [getD_range_map _ _ _ (perm_lt hπ ht')]
  simp only [flE, permFl_lo hf hπ fl ht32, permFl_hi hf hπ fl ht32, ht', decide_true, Bool.true_and]

end perm

/-! ## 8. numbers -/

theorem testBit_add_two_pow : ∀ (j a i : Nat), a.testBit j = false →
    (a + 2 ^ j).testBit i = (a.testBit i || decide (i = j))
  | 0, a, i, h => by
    simp only [Nat.testBit_zero, decide_eq_false_iff_not] at h
    cases i with
    | zero => simp <;> omega
    | succ i =>
      rw [Nat.testBit_succ, Nat.testBit_succ, show (a + 2 ^ 0) / 2 = a / 2 by simp; omega]; simp
  | j + 1, a, i, h => by
    rw [Nat.testBit_succ] at h
    cases i with
    | zero => simp [Nat.pow_succ] <;> omega
    | succ i =>
      rw [Nat.testBit_succ, Nat.testBit_succ, show (a + 2 ^ (j + 1)) / 2 = a / 2 + 2 ^ j by rw [Nat.pow_succ]; omega,
        testBit_add_two_pow j (a / 2) i h]
      simp

/-- Term of a plane sum: lane t with value v contributes bit 32 v + t. -/
def tm (q : Nat → Option Nat) (t : Nat) : Nat :=
  match q t with
  | none => 0
  | some v => 2 ^ (32 * v + t)

theorem sum_tm_bit (q : Nat → Option Nat) : ∀ k, k ≤ 32 → ∀ i,
    ((List.range k).map (tm q)).sum.testBit i = decide (i % 32 < k ∧ q (i % 32) = some (i / 32))
  | 0, _, i => by simp
  | k + 1, hk, i => by
    have IH := sum_tm_bit q k (by omega)
    rw [List.range_succ, List.map_append, List.sum_append]
    simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, Nat.add_zero]
    cases hq : q k with
    | none =>
      rw [show tm q k = 0 by simp [tm, hq], Nat.add_zero, IH, decide_eq_decide]
      by_cases hik : i % 32 = k
      · rw [hik, hq]; simp
      · constructor
        · rintro ⟨h1, h2⟩; exact ⟨by omega, h2⟩
        · rintro ⟨h1, h2⟩; exact ⟨by omega, h2⟩
    | some v =>
      rw [show tm q k = 2 ^ (32 * v + k) by simp [tm, hq]]
      rw [testBit_add_two_pow _ _ _ (by rw [IH]; simp only [decide_eq_false_iff_not, not_and]; intro h; omega), IH]
      by_cases hik : i % 32 = k
      · rw [hik, hq]
        have : (i = 32 * v + k) ↔ (v = i / 32) := by omega
        simp [this, eq_comm]
      · have : ¬ i = 32 * v + k := by omega
        simp only [this, decide_false, Bool.or_false, decide_eq_decide]
        constructor
        · rintro ⟨h1, h2⟩; exact ⟨by omega, h2⟩
        · rintro ⟨h1, h2⟩; exact ⟨by omega, h2⟩

theorem zipIdx_range_map {β : Type} (m : Nat) (g : Nat → β) :
    ((List.range m).map g).zipIdx = (List.range m).map fun t => (g t, t) := by
  apply List.ext_getElem (by simp)
  intro i h1 h2
  simp [List.getElem_zipIdx]

theorem numP_eq (p : PCol) : numP p = (p.hi.toNat <<< 64) ||| p.lo.toNat := by
  rw [numP, Nat.shiftLeft_eq, Nat.mul_comm, Nat.two_pow_add_eq_or_of_lt p.lo.toNat_lt, Nat.mul_comm]

theorem numP_bit (p : PCol) (q r : Nat) (hr : r < 32) :
    (numP p).testBit (32 * q + r) = (decide (q < 4) && planeBit p q r) := by
  rw [numP_eq, Nat.testBit_or, Nat.testBit_shiftLeft]
  have hlo := fun i (h : 64 ≤ i) => bitU_ge p.lo h
  have hhi := fun i (h : 64 ≤ i) => bitU_ge p.hi h
  simp only [bitU] at hlo hhi
  by_cases hq : q < 4
  · obtain rfl | rfl | rfl | rfl : q = 0 ∨ q = 1 ∨ q = 2 ∨ q = 3 := by omega
    · simp [pb0, bitU, show ¬ 64 ≤ r by omega]
    · simp [pb1, bitU, show ¬ 64 ≤ 32 + r by omega]
    · simp [pb2, bitU, hlo (64 + r) (by omega), show 64 ≤ 64 + r by omega]
    · simp [pb3, bitU, hlo (96 + r) (by omega), show 64 ≤ 96 + r by omega,
        show 96 + r - 64 = 32 + r by omega]
  · simp [hq, hlo (32 * q + r) (by omega), hhi (32 * q + r - 64) (by omega)]

theorem colNum_decode {f : FC} (hf : FCOK f) (p : PCol) (hp : WFcol f.c p) : colNum f.c (decodeCol f.c p) = numP p := by
  have hm := hf.hm
  have hn := hf.hn4
  have e : colNum f.c (decodeCol f.c p) = ((List.range f.c.m).map (tm fun t =>
      if laneValS f.c.n p t < f.c.n then some (laneValS f.c.n p t) else none)).sum := by
    unfold colNum decodeCol
    rw [zipIdx_range_map, List.map_map]
    congr 1
    apply List.map_congr_left
    intro t _
    by_cases h : laneValS f.c.n p t < f.c.n <;> simp [tm, h] <;> omega
  rw [e]
  apply Nat.eq_of_testBit_eq
  intro i
  obtain ⟨q, r, hr, rfl⟩ : ∃ q r, r < 32 ∧ i = 32 * q + r := ⟨i / 32, i % 32, Nat.mod_lt _ (by decide), by omega⟩
  rw [sum_tm_bit _ _ hm, numP_bit p q r hr, show (32 * q + r) % 32 = r by omega,
    show (32 * q + r) / 32 = q by omega]
  by_cases hq : q < 4
  · rw [wf_pb hp hq hr]
    by_cases h1 : r < f.c.m <;> by_cases h2 : laneValS f.c.n p r < f.c.n <;> simp [h1, h2, hq]
    all_goals (by_cases h3 : laneValS f.c.n p r = q <;> simp [h3] <;> omega)
  · simp only [hq, decide_false, Bool.false_and, decide_eq_false_iff_not, not_and]
    intro _; split <;> simp <;> omega

theorem flagNum_decode {f : FC} (hf : FCOK f) (fl : UInt64) (h : WFfl f.c fl) : flagNum (decodeFl f.c fl) = fl.toNat := by
  have hm := hf.hm
  have e : flagNum (decodeFl f.c fl) = ((List.range f.c.m).map (tm fun t =>
      match flE fl t with
      | .lt => some 0
      | .gt => some 1
      | .eq => none)).sum := by
    unfold flagNum
    rw [decodeFl_eq, zipIdx_range_map, List.map_map]
    congr 1
    apply List.map_congr_left
    intro t _
    cases hfe : flE fl t <;> simp [tm, hfe]
  rw [e]
  apply Nat.eq_of_testBit_eq
  intro i
  obtain ⟨q, r, hr, rfl⟩ : ∃ q r, r < 32 ∧ i = 32 * q + r := ⟨i / 32, i % 32, Nat.mod_lt _ (by decide), by omega⟩
  rw [sum_tm_bit _ _ hm, show (32 * q + r) % 32 = r by omega, show (32 * q + r) / 32 = q by omega]
  have hb := fun i (h : 64 ≤ i) => bitU_ge fl h
  simp only [bitU] at hb
  by_cases h1 : r < f.c.m
  · have hlo := wffl_lo h hr
    simp only [bitU] at hlo
    obtain rfl | rfl | hq : q = 0 ∨ q = 1 ∨ 2 ≤ q := by omega
    · simp only [flE, bitU, Nat.mul_zero, Nat.zero_add, h1, true_and]
      by_cases e1 : fl.toNat.testBit r = true <;> by_cases e2 : fl.toNat.testBit (32 + r) = true <;> simp [e1, e2]
    · simp only [flE, bitU, Nat.mul_one, h1, true_and]
      by_cases e1 : fl.toNat.testBit r = true <;> by_cases e2 : fl.toNat.testBit (32 + r) = true <;> simp [e1, e2]
      exact absurd (hlo e1).2 (by simp [e2])
    · rw [hb _ (by omega)]
      simp only [decide_eq_false_iff_not, not_and]
      intro _; simp only [flE]; split <;> (try split) <;> simp <;> omega
  · have hlo := wffl_lo_out h hr h1
    have hhi := wffl_hi_out h hm h1
    simp only [bitU] at hlo hhi
    simp only [h1, false_and, decide_false]
    obtain rfl | rfl | hq : q = 0 ∨ q = 1 ∨ 2 ≤ q := by omega
    · simp [hlo]
    · simp [hhi]
    · rw [hb _ (by omega)]

theorem pLt_iff (p q : PCol) : pLt p q = decide (numP p < numP q) := by
  have := p.lo.toNat_lt; have := q.lo.toNat_lt
  rw [Bool.eq_iff_iff]
  simp only [pLt, numP, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_iff, UInt64.lt_iff_toNat_lt, beq_iff_eq,
    ← UInt64.toNat_inj, show (2 : Nat) ^ 64 = 18446744073709551616 from rfl] at *
  omega

/-! ## 9. injectivity -/

theorem lo_bit (p : PCol) {i : Nat} (hi : i < 64) : bitU p.lo i = planeBit p (i / 32) (i % 32) := by
  unfold planeBit; rw [if_pos (by omega)]; congr 1; omega

theorem hi_bit (p : PCol) {i : Nat} (hi : i < 64) : bitU p.hi i = planeBit p (2 + i / 32) (i % 32) := by
  unfold planeBit; rw [if_neg (by omega)]; congr 1; omega

theorem decodeCol_inj {f : FC} (hf : FCOK f) {p q : PCol} (hp : WFcol f.c p) (hq : WFcol f.c q)
    (h : decodeCol f.c p = decodeCol f.c q) : p = q := by
  have hL : ∀ t < f.c.m, laneValS f.c.n p t = laneValS f.c.n q t := by
    intro t ht
    have := (List.map_inj_left.1 h) t (List.mem_range.2 ht)
    exact Int.ofNat.inj this
  have hpb : ∀ v < 4, ∀ t < 32, planeBit p v t = planeBit q v t := by
    intro v hv t ht
    rw [wf_pb hp hv ht, wf_pb hq hv ht]
    by_cases htm : t < f.c.m
    · rw [hL t htm]
    · simp [htm]
  have e1 : p.lo = q.lo := UInt64.ext_bit fun i hi => by
    rw [lo_bit p hi, lo_bit q hi]; exact hpb _ (by omega) _ (Nat.mod_lt _ (by decide))
  have e2 : p.hi = q.hi := UInt64.ext_bit fun i hi => by
    rw [hi_bit p hi, hi_bit q hi]; exact hpb _ (by omega) _ (Nat.mod_lt _ (by decide))
  cases p; cases q; simp_all

theorem flE_lt (x : UInt64) (t : Nat) : flE x t = .lt ↔ bitU x t = true := by
  unfold flE; split
  · simp_all
  · split <;> simp_all

theorem flE_gt {c : Ctx} {x : UInt64} (hx : WFfl c x) {t : Nat} (ht : t < 32) :
    flE x t = .gt ↔ bitU x (32 + t) = true := by
  unfold flE; split
  · rename_i h; simp [(wffl_lo hx ht h).2]
  · split <;> simp_all

theorem decodeFl_inj {f : FC} (hf : FCOK f) {a b : UInt64} (ha : WFfl f.c a) (hb : WFfl f.c b)
    (h : decodeFl f.c a = decodeFl f.c b) : a = b := by
  have hm := hf.hm
  rw [decodeFl_eq, decodeFl_eq] at h
  have hE : ∀ t < f.c.m, flE a t = flE b t := fun t ht => (List.map_inj_left.1 h) t (List.mem_range.2 ht)
  apply UInt64.ext_bit
  intro i hi
  by_cases h32 : i < 32
  · by_cases htm : i < f.c.m
    · rw [Bool.eq_iff_iff, ← flE_lt, ← flE_lt, hE i htm]
    · rw [wffl_lo_out ha h32 htm, wffl_lo_out hb h32 htm]
  · obtain ⟨t, rfl⟩ : ∃ t, i = 32 + t := ⟨i - 32, by omega⟩
    have ht : t < 32 := by omega
    by_cases htm : t < f.c.m
    · rw [Bool.eq_iff_iff, ← flE_gt ha ht, ← flE_gt hb ht, hE t htm]
    · rw [wffl_hi_out ha hm htm, wffl_hi_out hb hm htm]

/-! ## 10. one-hot planes of well-formed columns -/

theorem oh_bit {f : FC} (hf : FCOK f) (p : PCol) (hp : WFcol f.c p) (j : Nat) (hj : j < f.c.n) (t : Nat)
    (ht : t < 32) : bitU (p.oh j) t = (t < f.c.m && laneValS f.c.n p t == j) := by
  have hn := hf.hn4
  rw [bitU_oh p (by omega), ohv_wf hp hn ht]
  by_cases htm : t < f.c.m
  · by_cases h1 : laneValS f.c.n p t < f.c.n
    · simp [h1, ht, htm]
    · have hL : laneValS f.c.n p t = f.c.n := by have := laneValS_le f.c.n p t; omega
      rw [hL]; simp only [Nat.lt_irrefl, if_false, htm, decide_true, Bool.true_and, ht]
      rw [show (4 == j) = false from beq_false_of_ne (by omega),
        show (f.c.n == j) = false from beq_false_of_ne (by omega)]
  · have hL := lane_out hp hn ht htm
    rw [hL]; simp only [Nat.lt_irrefl, if_false, htm, decide_false, Bool.false_and, ht, decide_true,
      Bool.true_and]
    simp; omega

/-! ## 11. deadP -/

theorem ne_iff_bit (x y : UInt64) : x ≠ y ↔ ∃ i < 64, bitU x i ≠ bitU y i := by
  constructor
  · intro h
    exact Classical.byContradiction fun h' =>
      h (UInt64.ext_bit fun i hi => Classical.byContradiction fun e => h' ⟨i, hi, e⟩)
  · rintro ⟨i, _, e⟩ rfl; exact e rfl

theorem orPlane_foldl_bit (cols : List PCol) (j t : Nat) (a : UInt64) :
    bitU (cols.foldl (fun a c => a ||| c.oh j) a) t = (bitU a t || cols.any fun c => bitU (c.oh j) t) := by
  induction cols generalizing a with
  | nil => simp
  | cons c cs ih => simp [List.foldl, ih, Bool.or_assoc]

theorem orPlane_bit (cols : List PCol) (j t : Nat) :
    bitU (orPlane cols j) t = cols.any fun c => bitU (c.oh j) t := by
  simp [orPlane, orPlane_foldl_bit]

theorem any_oh {f : FC} (hf : FCOK f) {j : Nat} (hj : j < f.c.n) {t : Nat} (ht : t < 32) :
    ∀ (cols : List PCol), (∀ p ∈ cols, WFcol f.c p) →
      (cols.any fun c => bitU (c.oh j) t) = (decide (t < f.c.m) && cols.any fun c => laneValS f.c.n c t == j)
  | [], _ => by simp
  | c :: cs, hk => by
    rw [List.any_cons, List.any_cons, any_oh hf hj ht cs (fun p hp => hk p (List.mem_cons_of_mem _ hp)),
      oh_bit hf c (hk c List.mem_cons_self) j hj t ht, Bool.and_or_distrib_left]

theorem orPlane_ne {f : FC} (hf : FCOK f) (cols : List PCol) (hk : ∀ p ∈ cols, WFcol f.c p) {j : Nat}
    (hj : j < f.c.n) :
    (orPlane cols j != f.mask) = (List.range f.c.m).any fun i => !(cols.any fun p => laneValS f.c.n p i == j) := by
  have hm := hf.hm
  have hn := hf.hn4
  rw [Bool.eq_iff_iff, bne_iff_ne, ne_iff_bit, List.any_eq_true]
  constructor
  · rintro ⟨t, _, hne⟩
    rw [orPlane_bit, bitU_mask hf] at hne
    by_cases h32 : t < 32
    · rw [any_oh hf hj h32 cols hk] at hne
      by_cases htm : t < f.c.m
      · refine ⟨t, List.mem_range.2 htm, ?_⟩
        simp only [htm, decide_true, Bool.true_and] at hne
        cases e : cols.any fun p => laneValS f.c.n p t == j
        · rfl
        · simp [e] at hne
      · simp [htm] at hne
    · have : (cols.any fun c => bitU (c.oh j) t) = false := by
        simp [bitU_oh _ (show j < 4 by omega), h32]
      rw [this] at hne; simp [show ¬ t < f.c.m by omega] at hne
  · rintro ⟨i, hi, hnot⟩
    have him := List.mem_range.1 hi
    have h32 : i < 32 := by omega
    refine ⟨i, by omega, ?_⟩
    rw [orPlane_bit, bitU_mask hf, any_oh hf hj h32 cols hk]
    simp only [Bool.not_eq_true'] at hnot
    simp [hnot, him]

theorem any_congr' {α : Type} (L : List α) (F G : α → Bool) (h : ∀ x ∈ L, F x = G x) : L.any F = L.any G := by
  induction L with
  | nil => rfl
  | cons x L ih =>
    rw [List.any_cons, List.any_cons, h x List.mem_cons_self, ih (fun y hy => h y (List.mem_cons_of_mem _ hy))]

theorem deadP_eq {f : FC} (hf : FCOK f) (k : PKey) (hk : ∀ p ∈ k.cols, WFcol f.c p) :
    deadP f k = dead f.c (decodeK f.c k) := by
  have hu : undone f.c (decodeK f.c k) = undoneP f k := rfl
  unfold deadP dead
  simp only [hu]
  apply any_congr'
  intro j hj
  have hjn : j < f.c.n := by
    simp only [undoneP, List.mem_filter, List.mem_range] at hj; exact hj.1
  rw [orPlane_ne hf k.cols hk hjn]
  apply any_congr'
  intro i hi
  have him := List.mem_range.1 hi
  simp only [decodeK, List.map_map, List.any_map, Function.comp_def, cget_toArray', decodeCol,
    getD_range_map _ _ _ him]
  congr 1
  apply any_congr'
  intro p _
  by_cases e : laneValS f.c.n p i = j
  · simp [e]
  · have : ¬ ((laneValS f.c.n p i : Nat) : Int) = (j : Int) := by omega
    rw [beq_false_of_ne e, beq_false_of_ne this]

/-! ## 12. the T column -/

theorem WF_tcode {f : FC} (hf : FCOK f) : WFcol f.c f.tcode := by
  rw [hf.tcode]; intro v _ t _ h; simp [planeBit] at h

theorem decode_tcode {f : FC} (hf : FCOK f) (hT : f.c.T = List.replicate f.c.m (f.c.n : Int)) :
    decodeCol f.c f.tcode = f.c.T := by
  rw [hf.tcode, hT]
  simp [decodeCol, laneValS_zero, List.map_const']

end LeanReflect.FP
