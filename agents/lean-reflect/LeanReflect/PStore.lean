import LeanReflect.FastP
/-
  Packed in-memory certificate store (plan D). Untrusted layout: soundness only uses `lookF_sound`
  (a lookup returns `some g` only after the full decoded record equals the key), so a wrong loader can only make
  the check fail.
  Record (rb bytes): 64-bit header = fl lt bits (m) | fl gt bits (m) | done (n) | gam (3) | g (5) | ncols (4),
  then 5 bits relabelling index π, then ncols column ids of `ib` bits (file column table).
  The key of a record = columns `permCol tabs[π] cols[id]` (in record order), the stored flags, done and gam.
  Two record areas: A (few columns, rbA bytes) and B (more columns, rbB bytes).
  Slot table: 4 bytes per slot, 0 = empty, else (area bit 31) | (index + 1).
-/
namespace LeanReflect.FP

structure Store where
  n : Nat
  m : Nat
  cols : Array PCol
  tabs : Array (Array Nat)
  ib : Nat
  rbA : Nat
  nA : Nat
  dA : ByteArray
  rbB : Nat
  nB : Nat
  dB : ByteArray
  nsl : Nat
  sl : ByteArray
deriving Inhabited

@[inline] def rd8 (d : ByteArray) (o : Nat) : UInt64 := (d.get! o).toUInt64

def rd64 (d : ByteArray) (o : Nat) : UInt64 :=
  rd8 d o ||| (rd8 d (o + 1) <<< 8) ||| (rd8 d (o + 2) <<< 16) ||| (rd8 d (o + 3) <<< 24) |||
  (rd8 d (o + 4) <<< 32) ||| (rd8 d (o + 5) <<< 40) ||| (rd8 d (o + 6) <<< 48) ||| (rd8 d (o + 7) <<< 56)

def rd32 (d : ByteArray) (o : Nat) : UInt64 :=
  rd8 d o ||| (rd8 d (o + 1) <<< 8) ||| (rd8 d (o + 2) <<< 16) ||| (rd8 d (o + 3) <<< 24)

/-- `w ≤ 56` bits at bit position `pos`. -/
@[inline] def bitsAt (d : ByteArray) (pos w : Nat) : Nat :=
  ((rd64 d (pos / 8) >>> (pos % 8).toUInt64) &&& ((1 <<< w.toUInt64) - 1)).toNat

section
variable (s : Store)

@[inline] def mmask : UInt64 := (1 <<< s.m.toUInt64) - 1

/-- Header bits without the g field. -/
def hdrMask : UInt64 :=
  let o := 2 * s.m + s.n
  ((1 <<< (o + 3).toUInt64) - 1) ||| ((15 : UInt64) <<< (o + 8).toUInt64)

def keyHdr (k : PKey) : UInt64 :=
  let o := 2 * s.m
  let d := (k.done.zipIdx.foldl (fun (acc : UInt64) (b, j) => if b then acc ||| ((1 : UInt64) <<< (o + j).toUInt64) else acc) (0 : UInt64))
  (k.fl &&& mmask s) ||| (((k.fl >>> 32) &&& mmask s) <<< s.m.toUInt64) ||| d |||
    ((k.gam.toUInt64 &&& 7) <<< (o + s.n).toUInt64) |||
    ((k.cols.length.toUInt64 &&& 15) <<< (o + s.n + 8).toUInt64)

def decRec (d : ByteArray) (rb i : Nat) : PKey × Nat :=
  let base := i * rb
  let h := rd64 d base
  let o := 2 * s.m
  let fl := (h &&& mmask s) ||| (((h >>> s.m.toUInt64) &&& mmask s) <<< 32)
  let done := (List.range s.n).map fun j => (h >>> (o + j).toUInt64) &&& 1 == 1
  let gam := ((h >>> (o + s.n).toUInt64) &&& 7).toNat
  let g := ((h >>> (o + s.n + 3).toUInt64) &&& 31).toNat
  let nc := ((h >>> (o + s.n + 8).toUInt64) &&& 15).toNat
  let tab := s.tabs.getD (bitsAt d (base * 8 + 64) 5) #[]
  let cols := (List.range nc).map fun j => permCol tab (s.cols.getD (bitsAt d (base * 8 + 69 + j * s.ib) s.ib) default)
  ({ cols, fl, done, gam }, g)

def entries : List (PKey × Nat) :=
  (List.range s.nA).map (decRec s s.dA s.rbA) ++ (List.range s.nB).map (decRec s s.dB s.rbB)

def mixH (x : UInt64) : UInt64 :=
  let x := (x ^^^ (x >>> 33)) * 0xff51afd7ed558ccd
  let x := (x ^^^ (x >>> 33)) * 0xc4ceb9fe1a85ec53
  x ^^^ (x >>> 33)

def slotOf (k : PKey) : Nat := (mixH (hash k)).toNat % s.nsl

def probe (k : PKey) (kh : UInt64) : Nat → Nat → Option Nat
  | 0, _ => none
  | fuel + 1, p =>
    let v := rd32 s.sl (4 * p)
    if v == 0 then none else
    let isB := v >>> 31 == 1
    let idx := ((v &&& 0x7FFFFFFF) - 1).toNat
    let nxt := (p + 1) % s.nsl
    let d := if isB then s.dB else s.dA
    let rb := if isB then s.rbB else s.rbA
    let nn := if isB then s.nB else s.nA
    if idx < nn && (rd64 d (idx * rb) &&& hdrMask s) == kh then
      let e := decRec s d rb idx
      if e.1 == k then some e.2 else probe k kh fuel nxt
    else probe k kh fuel nxt

def lookF (k : PKey) : Option Nat := probe s k (keyHdr s k) s.nsl (slotOf s k)

theorem probe_sound (k : PKey) (kh : UInt64) : ∀ fuel p g, probe s k kh fuel p = some g → (k, g) ∈ entries s
  | 0, p, g, h => by simp [probe] at h
  | fuel + 1, p, g, h => by
    unfold probe at h
    dsimp only at h
    have ih := probe_sound k kh fuel ((p + 1) % s.nsl) g
    by_cases h0 : (rd32 s.sl (4 * p) == 0) = true
    · rw [if_pos h0] at h; simp at h
    rw [if_neg h0] at h
    generalize ((rd32 s.sl (4 * p) &&& 0x7FFFFFFF) - 1).toNat = idx at h
    unfold entries
    rw [List.mem_append]
    by_cases hB : (rd32 s.sl (4 * p) >>> 31 == 1) = true
    · simp only [hB, ↓reduceIte] at h
      by_cases hc : (decide (idx < s.nB) && (rd64 s.dB (idx * s.rbB) &&& hdrMask s == kh)) = true
      · rw [if_pos hc] at h
        by_cases he : ((decRec s s.dB s.rbB idx).1 == k) = true
        · rw [if_pos he] at h
          simp only [Bool.and_eq_true, decide_eq_true_eq] at hc
          simp only [Option.some.injEq] at h
          simp only [beq_iff_eq] at he
          right
          exact List.mem_map.2 ⟨idx, List.mem_range.2 hc.1, by rw [← he, ← h]⟩
        · rw [if_neg he] at h; rw [← List.mem_append]; exact ih h
      · rw [if_neg hc] at h; rw [← List.mem_append]; exact ih h
    · simp only [Bool.not_eq_true] at hB
      simp only [hB, Bool.false_eq_true, ↓reduceIte] at h
      by_cases hc : (decide (idx < s.nA) && (rd64 s.dA (idx * s.rbA) &&& hdrMask s == kh)) = true
      · rw [if_pos hc] at h
        by_cases he : ((decRec s s.dA s.rbA idx).1 == k) = true
        · rw [if_pos he] at h
          simp only [Bool.and_eq_true, decide_eq_true_eq] at hc
          simp only [Option.some.injEq] at h
          simp only [beq_iff_eq] at he
          left
          exact List.mem_map.2 ⟨idx, List.mem_range.2 hc.1, by rw [← he, ← h]⟩
        · rw [if_neg he] at h; rw [← List.mem_append]; exact ih h
      · rw [if_neg hc] at h; rw [← List.mem_append]; exact ih h

theorem lookF_sound (k : PKey) (g : Nat) (h : lookF s k = some g) : (k, g) ∈ entries s :=
  probe_sound s k _ _ _ g h

end

/-! ## Loops over index ranges -/

def allRange (p : Nat → Bool) (lo hi : Nat) : Bool :=
  if lo < hi then p lo && allRange p (lo + 1) hi else true
termination_by hi - lo

theorem allRange_sound (p : Nat → Bool) (hi : Nat) : ∀ d lo, hi - lo = d → allRange p lo hi = true →
    ∀ i, lo ≤ i → i < hi → p i = true := by
  intro d
  induction d with
  | zero => intro lo hd _ i h1 h2; omega
  | succ d ih =>
    intro lo hd h i h1 h2
    have hlt : lo < hi := by omega
    rw [allRange, if_pos hlt, Bool.and_eq_true] at h
    rcases Nat.eq_or_lt_of_le h1 with e | e
    · rw [← e]; exact h.1
    · exact ih (lo + 1) (by omega) h.2 i e h2

/-- Strided loop: i = r, r + T, r + 2T, … < N. -/
def allStride (p : Nat → Bool) (T N r : Nat) : Bool :=
  if r < N then p r && allStride p T N (r + max T 1) else true
termination_by N - r
decreasing_by omega

theorem allStride_sound (p : Nat → Bool) (T N : Nat) (hT : 0 < T) : ∀ d r, N - r = d → allStride p T N r = true →
    ∀ i, r ≤ i → i < N → i % T = r % T → p i = true := by
  intro d
  induction d using Nat.strongRecOn with
  | ind d ih =>
    intro r hd h i h1 h2 h3
    have hlt : r < N := by omega
    rw [allStride, if_pos hlt, Bool.and_eq_true] at h
    rcases Nat.eq_or_lt_of_le h1 with e | e
    · rw [← e]; exact h.1
    · have hm : max T 1 = T := by omega
      rw [hm] at h
      apply ih (N - (r + T)) (by omega) (r + T) rfl h.2 i _ h2
      · rw [h3, Nat.add_mod_right]
      · have e1 := Nat.div_add_mod i T
        have e2 := Nat.div_add_mod r T
        have hq : r / T < i / T := by
          apply Nat.lt_of_not_le; intro hle
          have := Nat.mul_le_mul_left T hle
          omega
        have := Nat.mul_le_mul_left T (Nat.succ_le_of_lt hq)
        rw [Nat.mul_succ] at this
        omega

def allPar (p : Nat → Bool) (T N : Nat) : Bool :=
  ((List.range T).map fun r => Task.spawn fun _ => allStride p T N r).all Task.get

theorem allPar_sound (p : Nat → Bool) (T N : Nat) (hT : 0 < T) (h : allPar p T N = true) :
    ∀ i < N, p i = true := by
  intro i hi
  simp only [allPar, List.all_eq_true, List.mem_map, List.mem_range] at h
  have := h _ ⟨i % T, Nat.mod_lt _ hT, rfl⟩
  exact allStride_sound p T N hT _ (i % T) rfl this i (Nat.mod_le _ _) hi (Nat.mod_mod i T).symm

end LeanReflect.FP
