import LeanReflect.PlaneSucc
import LeanReflect.PStore
import LeanReflect.NGMain
/-
  The fast check over a packed store implies `checkNG` on the decoded entries, hence the strict lower bound.
  The spec lookup `lookS` is classical (the fast lookup on the unique well-formed preimage of a key).
-/
namespace LeanReflect.FP
open SortProof LeanReflect

instance (c : Ctx) (k : PKey) : Decidable (WFkey c k) := by unfold WFkey; infer_instance

def recOK (f : FC) (KB : Nat) (s : Store) (e : PKey × Nat) : Bool :=
  decide (WFkey f.c e.1) && stateOKP2 f I1 KB (lookF s) e.1 e.2

def checkStore (f : FC) (KB T : Nat) (s : Store) (rP : PKey) : Bool :=
  lookF s (canonP f rP) == some 0 &&
  allPar (fun i => recOK f KB s (decRec s s.dA s.rbA i)) T s.nA &&
  allPar (fun i => recOK f KB s (decRec s s.dB s.rbB i)) T s.nB

theorem decodeK_inj {f : FC} (hf : FCOK f) {a b : PKey} (ha : WFkey f.c a) (hb : WFkey f.c b)
    (h : decodeK f.c a = decodeK f.c b) : a = b := by
  have h1 := congrArg Key.cols h
  have h2 := congrArg Key.flag h
  have h3 := congrArg Key.done h
  have h4 := congrArg Key.gam h
  simp only [decodeK] at h1 h2 h3 h4
  have e1 := map_decode_inj hf ha.1 hb.1 h1
  have e2 := decodeFl_inj hf ha.2 hb.2 h2
  cases a; cases b
  simp only at e1 e2 h3 h4
  rw [e1, e2, h3, h4]

open Classical in
noncomputable def lookS (f : FC) (lf : PKey → Option Nat) (K : Key) : Option Nat :=
  if h : ∃ kc, WFkey f.c kc ∧ decodeK f.c kc = K then lf (Classical.choose h) else none

theorem lookS_dec {f : FC} (hf : FCOK f) (lf : PKey → Option Nat) (kc : PKey) (hk : WFkey f.c kc) :
    lookS f lf (decodeK f.c kc) = lf kc := by
  have hex : ∃ k', WFkey f.c k' ∧ decodeK f.c k' = decodeK f.c kc := ⟨kc, hk, rfl⟩
  unfold lookS
  rw [dif_pos hex]
  have := Classical.choose_spec hex
  rw [decodeK_inj hf this.1 hk this.2]

def specS (f : FC) (s : Store) : List (Key × Nat) := (entries s).map fun e => (decodeK f.c e.1, e.2)

theorem lookS_sound (f : FC) (s : Store) (K : Key) (g : Nat) (h : lookS f (lookF s) K = some g) :
    (K, g) ∈ specS f s := by
  unfold lookS at h
  split at h
  · rename_i hex
    have hsp := Classical.choose_spec hex
    have := lookF_sound s _ g h
    unfold specS
    exact List.mem_map.2 ⟨_, this, by rw [hsp.2]⟩
  · simp at h

theorem checkStore_checkNG {f : FC} (hf : FCOK f) (hcx : CtxOK f.c)
    (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m))
    (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (KB T : Nat) (hT : 0 < T) (s : Store) (rP : PKey) (hrw : WFkey f.c rP) (hr : decodeK f.c rP = root f.c)
    (h : checkStore f KB T s rP = true) :
    checkNG f.c (group f.c) I1 KB (specS f s) (lookS f (lookF s)) = true := by
  simp only [checkStore, Bool.and_eq_true] at h
  obtain ⟨⟨hroot, hA⟩, hB⟩ := h
  have hA' := allPar_sound _ T _ hT hA
  have hB' := allPar_sound _ T _ hT hB
  have hlk := fun kc hk => lookS_dec hf (lookF s) kc hk
  obtain ⟨hcan, hwc⟩ := decode_canonP hf hcx hgo rP hrw
  unfold checkNG
  rw [Bool.and_eq_true]
  refine ⟨?_, ?_⟩
  · rw [← hr, ← hcan, hlk _ hwc]; exact hroot
  · unfold specS
    rw [List.all_map, List.all_eq_true]
    intro e he
    have hok : recOK f KB s e = true := by
      unfold entries at he
      rcases List.mem_append.1 he with he | he
      · obtain ⟨i, hi, rfl⟩ := List.mem_map.1 he
        exact hA' i (List.mem_range.1 hi)
      · obtain ⟨i, hi, rfl⟩ := List.mem_map.1 he
        exact hB' i (List.mem_range.1 hi)
    simp only [recOK, Bool.and_eq_true, decide_eq_true_eq] at hok
    exact stateOKP2_sound hf hcx hgo hinv5 (lookF s) (lookS f (lookF s)) hlk I1 KB e.1 e.2 hok.1 hok.2

theorem lower_bound_store (n KB T : Nat) (hn2 : 2 ≤ n) (hn : n < 2 ^ 31 - 1) (hT : 0 < T)
    (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) (group (mkCtx n)))
    (hf : FCOK (mkFC (mkCtx n)))
    (hinv5 : ∀ t < (mkCtx n).m, ∀ v ≤ n, (mkFC (mkCtx n)).inv.getD (t * 8 + v) 0 < 5)
    (rP : PKey) (hrw : WFkey (mkCtx n) rP) (hr : decodeK (mkCtx n) rP = root (mkCtx n))
    (s : Store) (h : checkStore (mkFC (mkCtx n)) KB T s rP = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → ¬ XSnap n p o :=
  lower_bound_strict n KB hn2 hn (group (mkCtx n)) hc hs hgo _ _
    (lookS_sound (mkFC (mkCtx n)) s)
    (checkStore_checkNG (f := mkFC (mkCtx n)) hf hc hgo.perm hinv5 KB T hT s rP hrw hr h)

end LeanReflect.FP
