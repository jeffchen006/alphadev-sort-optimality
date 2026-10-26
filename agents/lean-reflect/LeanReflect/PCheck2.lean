import LeanReflect.PCheck
import LeanReflect.NGSound2
import LeanReflect.PlaneHc3
/-
  Fast check in the order of `checkNG2`: H bound on the raw successor first, canonical form and lookup only after.
-/
namespace LeanReflect.FP
open SortProof LeanReflect
set_option linter.unusedSectionVars false

section
variable (f : FC)

def fastOKP3 (cands : List (Array Nat)) (KB Gc : Nat) (look : PKey → Option Nat) (k0 : PKey) : Bool :=
  decide (KB < Gc + (undoneP f k0).length) || deadP f k0 || hPrune f KB Gc k0 ||
    (match look (canonWith f cands k0) with
     | some g' => decide (g' ≤ Gc)
     | none => false)

def stateOKP3 (cs : List Cond) (KB : Nat) (look : PKey → Option Nat) (k : PKey) (g : Nat) : Bool :=
  let cp := candsP f (canonF k.fl)
  !(undoneP f k).isEmpty && ngAll f cs k fun (k', w) =>
    fastOKP3 f (if k'.fl == canonF k.fl then cp else candsP f k'.fl) KB (g + w) look k'

def recOK3 (KB : Nat) (s : Store) (e : PKey × Nat) : Bool :=
  decide (WFkey f.c e.1) && stateOKP3 f I1 KB (lookF s) e.1 e.2

def checkStore3 (KB T : Nat) (s : Store) (rP : PKey) : Bool :=
  lookF s (canonP f rP) == some 0 &&
  allPar (fun i => recOK3 f KB s (decRec s s.dA s.rbA i)) T s.nA &&
  allPar (fun i => recOK3 f KB s (decRec s s.dB s.rbB i)) T s.nB
end

section
variable {f : FC} (hf : FCOK f) (hcx : CtxOK f.c)
include hf hcx

theorem hPrune_sound (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5) (KB G : Nat) (k : PKey)
    (hk : WFkey f.c k) (h : hPrune f KB G k = true) : KB < G + hB f.c (decodeK f.c k) (KB + 3 - G) := by
  have hu : (undone f.c (decodeK f.c k)).length = (undoneP f k).length := rfl
  unfold hPrune at h
  dsimp only at h
  rw [hcP2_eq_of_inv5 (hf := hf) (hinv5 := hinv5), maxCoverBP_eq f hf _ hk.1] at h
  simp only [hB, hu, Bool.or_eq_true, decide_eq_true_eq] at h ⊢
  have hm := maxCoverB_mono hf hcx (decodeK f.c k)
    (show KB + 3 - G - hc f.c (decodeK f.c k) - (undoneP f k).length ≤ KB + 3 - G by omega)
  rcases h with h | h <;> omega

theorem fastOKP3_sound (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m))
    (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (lookF : PKey → Option Nat) (lookS : Key → Option Nat) (hlk : ∀ kc, WFkey f.c kc → lookS (decodeK f.c kc) = lookF kc)
    (KB Gc : Nat) (k0 : PKey) (hk0 : WFkey f.c k0) (h : fastOKP3 f (candsP f k0.fl) KB Gc lookF k0 = true) :
    fastOK2 f.c (group f.c) KB Gc lookS (decodeK f.c k0) = true := by
  have hu : ∀ k : PKey, (undone f.c (decodeK f.c k)).length = (undoneP f k).length := fun _ => rfl
  obtain ⟨hcan, hwc⟩ := decode_canonP hf hcx hgo k0 hk0
  unfold fastOKP3 at h
  rw [canonWith_cands hf hcx] at h
  unfold fastOK2 succOKG
  rw [hu, deadP_eq hf k0 hk0.1 |>.symm, ← hcan, hlk _ hwc]
  simp only [Bool.or_eq_true] at h ⊢
  rcases h with ((h | h) | h) | h
  · exact Or.inl (Or.inl (Or.inl h))
  · exact Or.inl (Or.inl (Or.inr h))
  · exact Or.inl (Or.inr (by simpa using hPrune_sound hf hcx hinv5 KB Gc k0 hk0 h))
  · exact Or.inr (Or.inl (Or.inl h))

theorem stateOKP3_sound (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m))
    (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (lookF : PKey → Option Nat) (lookS : Key → Option Nat) (hlk : ∀ kc, WFkey f.c kc → lookS (decodeK f.c kc) = lookF kc)
    (cs : List Cond) (KB : Nat) (k : PKey) (g : Nat) (hk : WFkey f.c k) (h : stateOKP3 f cs KB lookF k g = true) :
    (!isGoal f.c (decodeK f.c k) &&
      (ngSuccs f.c cs (decodeK f.c k)).all fun (k', w) => fastOK2 f.c (group f.c) KB (g + w) lookS k') = true := by
  unfold stateOKP3 at h
  dsimp only at h
  rw [ngAll_eq] at h
  simp only [Bool.and_eq_true] at h ⊢
  refine ⟨h.1, ?_⟩
  rw [← decode_ngSuccs hf hcx cs k hk, List.all_map]
  rw [List.all_eq_true] at h ⊢
  intro e he
  have hwe := wf_ngSuccs hf hcx cs k hk e he
  have h2 := h.2 e he
  have hc : (if e.1.fl == FP.canonF k.fl then candsP f (FP.canonF k.fl) else candsP f e.1.fl) = candsP f e.1.fl := by
    split
    · next he' => rw [beq_iff_eq.1 he']
    · rfl
  simp only [hc] at h2
  exact fastOKP3_sound hf hcx hgo hinv5 lookF lookS hlk KB (g + e.2) e.1 hwe h2

theorem checkStore3_checkNG2 (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m))
    (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (KB T : Nat) (hT : 0 < T) (s : Store) (rP : PKey) (hrw : WFkey f.c rP) (hr : decodeK f.c rP = root f.c)
    (h : checkStore3 f KB T s rP = true) :
    checkNG2 f.c (group f.c) I1 KB (specS f s) (lookS f (lookF s)) = true := by
  simp only [checkStore3, Bool.and_eq_true] at h
  obtain ⟨⟨hroot, hA⟩, hB⟩ := h
  have hA' := allPar_sound _ T _ hT hA
  have hB' := allPar_sound _ T _ hT hB
  have hlk := fun kc hk => lookS_dec hf (lookF s) kc hk
  obtain ⟨hcan, hwc⟩ := decode_canonP hf hcx hgo rP hrw
  unfold checkNG2
  rw [Bool.and_eq_true]
  refine ⟨?_, ?_⟩
  · rw [← hr, ← hcan, hlk _ hwc]; exact hroot
  · unfold specS
    rw [List.all_map, List.all_eq_true]
    intro e he
    have hok : recOK3 f KB s e = true := by
      unfold entries at he
      rcases List.mem_append.1 he with he | he
      · obtain ⟨i, hi, rfl⟩ := List.mem_map.1 he
        exact hA' i (List.mem_range.1 hi)
      · obtain ⟨i, hi, rfl⟩ := List.mem_map.1 he
        exact hB' i (List.mem_range.1 hi)
    simp only [recOK3, Bool.and_eq_true, decide_eq_true_eq] at hok
    exact stateOKP3_sound hf hcx hgo hinv5 (lookF s) (lookS f (lookF s)) hlk I1 KB e.1 e.2 hok.1 hok.2
end

theorem lower_bound_store3 (n KB T : Nat) (hn2 : 2 ≤ n) (hn : n < 2 ^ 31 - 1) (hT : 0 < T)
    (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) (group (mkCtx n)))
    (hf : FCOK (mkFC (mkCtx n)))
    (hinv5 : ∀ t < (mkCtx n).m, ∀ v ≤ n, (mkFC (mkCtx n)).inv.getD (t * 8 + v) 0 < 5)
    (rP : PKey) (hrw : WFkey (mkCtx n) rP) (hr : decodeK (mkCtx n) rP = root (mkCtx n))
    (s : Store) (h : checkStore3 (mkFC (mkCtx n)) KB T s rP = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → ¬ XSnap n p o :=
  lower_bound_strict2 n KB hn2 hn (group (mkCtx n)) hc hs hgo _ _
    (lookS_sound (mkFC (mkCtx n)) s)
    (checkStore3_checkNG2 (f := mkFC (mkCtx n)) hf hc hgo.perm hinv5 KB T hT s rP hrw hr h)

end LeanReflect.FP
