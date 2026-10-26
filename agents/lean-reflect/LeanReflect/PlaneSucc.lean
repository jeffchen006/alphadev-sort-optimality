import LeanReflect.PlaneMain
/-
  The fast per-state check implies the spec's per-state check of `checkNG` on the decoded key.
-/
namespace LeanReflect.FP
open SortProof LeanReflect
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

theorem all_ite_nil {α : Type} (b : Bool) (l : List α) (P : α → Bool) :
    (if b = true then [] else l).all P = (b || l.all P) := by
  cases b <;> simp

theorem ngAll_eq (f : FC) (cs : List Cond) (k : PKey) (P : PKey × Nat → Bool) :
    ngAll f cs k P = (ngSuccsP f cs k).all P := by
  by_cases hg : 1 ≤ k.gam <;> by_cases h7 : k.gam < 7 <;>
    simp only [ngAll, ngSuccsP, hg, h7, if_true, if_false, decide_true, decide_false, Bool.not_true,
      Bool.not_false, Bool.true_or, Bool.false_or, Bool.and_true, List.all_append, List.all_flatMap, List.all_map,
      all_ite_nil, List.all_cons, List.all_nil, Function.comp_def, List.all_nil]

theorem flatMap_congr' {α β : Type} {l : List α} {g h : α → List β} (H : ∀ x ∈ l, g x = h x) :
    l.flatMap g = l.flatMap h := by
  induction l with
  | nil => rfl
  | cons a l ih => simp only [List.flatMap_cons]; rw [H a (by simp), ih (fun x hx => H x (by simp [hx]))]

theorem dK_fl (c : Ctx) (k : PKey) (y : UInt64) :
    decodeK c { k with fl := y } = { decodeK c k with flag := decodeFl c y } := rfl
theorem dK_cols (c : Ctx) (k : PKey) (l : List PCol) :
    decodeK c { k with cols := l } = { decodeK c k with cols := l.map (decodeCol c) } := rfl
theorem dK_colsg (c : Ctx) (k : PKey) (l : List PCol) (g : Nat) :
    decodeK c { k with cols := l, gam := g } = { decodeK c k with cols := l.map (decodeCol c), gam := g } := rfl
theorem dK_gam (c : Ctx) (k : PKey) (g : Nat) :
    decodeK c { k with gam := g } = { decodeK c k with gam := g } := rfl

section
variable {f : FC} (hf : FCOK f) (hcx : CtxOK f.c)
include hf

theorem decodeCol_beq {a b : PCol} (ha : WFcol f.c a) (hb : WFcol f.c b) :
    (decodeCol f.c a == decodeCol f.c b) = (a == b) := by
  cases e : (a == b) <;> cases e2 : (decodeCol f.c a == decodeCol f.c b) <;> try rfl
  · exfalso; simp only [beq_iff_eq] at e2; rw [decodeCol_inj hf ha hb e2] at e; simp at e
  · exfalso; simp only [beq_iff_eq] at e; rw [e] at e2; simp at e2

theorem decode_erase : ∀ {A : List PCol} {d : PCol}, (∀ p ∈ A, WFcol f.c p) → WFcol f.c d →
    (A.erase d).map (decodeCol f.c) = (A.map (decodeCol f.c)).erase (decodeCol f.c d)
  | [], _, _, _ => rfl
  | a :: A, d, hA, hd => by
    have ha := hA a (by simp)
    have ih := decode_erase (A := A) (fun p hp => hA p (by simp [hp])) hd
    simp only [List.erase_cons, List.map_cons]
    rw [decodeCol_beq hf ha hd]
    split <;> simp [ih]

theorem wf_erase {A : List PCol} {d : PCol} (hA : ∀ p ∈ A, WFcol f.c p) : ∀ p ∈ A.erase d, WFcol f.c p :=
  fun p hp => hA p (List.mem_of_mem_erase hp)

include hcx

theorem decode_ngSuccs (cs : List Cond) (k : PKey) (hk : WFkey f.c k) :
    (ngSuccsP f cs k).map (fun e => (decodeK f.c e.1, e.2)) = ngSuccs f.c cs (decodeK f.c k) := by
  have hT : decodeCol f.c f.tcode = f.c.T := decode_tcode hf hcx.hT
  have hwT := WF_tcode hf
  have hA : (decodeK f.c k).cols = k.cols.map (decodeCol f.c) := rfl
  have hF : (decodeK f.c k).flag = decodeFl f.c k.fl := rfl
  have hG : (decodeK f.c k).gam = k.gam := rfl
  have hwA := hk.1
  have hwS : ∀ p ∈ (if 1 ≤ k.gam then k.cols ++ [f.tcode] else k.cols), WFcol f.c p := by
    intro p hp; split at hp
    · rcases List.mem_append.1 hp with h | h
      · exact hwA p h
      · rw [List.mem_singleton.1 h]; exact hwT
    · exact hwA p hp
  have hsrc : (if 1 ≤ k.gam then k.cols ++ [f.tcode] else k.cols).map (decodeCol f.c) =
      (if 1 ≤ k.gam then k.cols.map (decodeCol f.c) ++ [f.c.T] else k.cols.map (decodeCol f.c)) := by
    split <;> simp [hT]
  have hD : (decodeK f.c k).done = k.done := rfl
  have hN : ∀ (cols : List PCol) (fl : UInt64) (g : Nat), (∀ p ∈ cols, WFcol f.c p) → WFfl f.c fl →
      decodeK f.c (normP f { cols := cols, fl := fl, done := k.done, gam := g }) =
        norm f.c { cols := cols.map (decodeCol f.c), flag := decodeFl f.c fl, done := k.done, gam := g } :=
    fun cols fl g h1 h2 => (decode_normP hf hcx _ ⟨h1, h2⟩).1
  unfold ngSuccsP ngSuccs
  simp only [hA, hF, hG, hD, List.map_append]
  rw [← hsrc]
  congr 1
  congr 1
  congr 1
  · rw [List.map_flatMap, List.flatMap_map]
    apply flatMap_congr'; intro a ha
    rw [List.map_map, List.map_map]
    apply List.map_congr_left; intro b hb
    simp only [Function.comp_def]
    rw [hN _ _ _ hwA (WF_cmpFl hf a b), decode_cmpFl hf a b (hwS a ha) (hwS b hb)]
  · rw [List.map_flatMap, List.flatMap_map]
    apply flatMap_congr'; intro d hd
    rw [List.map_flatMap, List.flatMap_map]
    apply flatMap_congr'; intro s hs
    rw [List.map_flatMap]
    apply flatMap_congr'; intro cd _
    have hwd := hwA d hd
    have hwM := WF_merge_cond hf cd k.fl d s hwd (hwS s hs)
    rw [← decode_merge hf cd k.fl hk.2, decodeCol_beq hf hwM hwd, ← hT, decodeCol_beq hf hwM hwT,
      mem_map_decode hf hwA hwM]
    split
    · rfl
    · simp only [List.map_cons, List.map_nil]
      rw [hN _ _ _ (fun p hp => by
            rcases List.mem_cons.1 hp with h | h
            · rw [h]; exact hwM
            · exact wf_erase hf hwA p h) hk.2,
        hN _ _ _ (fun p hp => by
            rcases List.mem_cons.1 hp with h | h
            · rw [h]; exact hwM
            · exact hwA p h) hk.2,
        List.map_cons, List.map_cons, decode_erase hf hwA hwd]
  · split
    · rw [List.map_flatMap, List.flatMap_map]
      apply flatMap_congr'; intro s hs
      rw [List.map_flatMap]
      apply flatMap_congr'; intro cd _
      have hwM := WF_merge_cond hf cd k.fl f.tcode s hwT (hwA s hs)
      rw [← hT, ← decode_merge hf cd k.fl hk.2, decodeCol_beq hf hwM hwT, mem_map_decode hf hwA hwM]
      split
      · rfl
      · simp only [List.map_cons, List.map_nil]
        rw [hN _ _ _ (fun p hp => by
              rcases List.mem_cons.1 hp with h | h
              · rw [h]; exact hwM
              · exact hwA p h) hk.2, List.map_cons]
    · rfl
  · split
    · simp only [List.map_cons, List.map_nil]
      rw [hN _ _ _ hwA hk.2]
    · rfl

theorem wf_ngSuccs (cs : List Cond) (k : PKey) (hk : WFkey f.c k) : ∀ e ∈ ngSuccsP f cs k, WFkey f.c e.1 := by
  have hwT := WF_tcode hf
  have hwA := hk.1
  have hW : ∀ k' : PKey, WFkey f.c k' → WFkey f.c (normP f k') := fun k' h => (decode_normP hf hcx k' h).2
  have hwS : ∀ p ∈ (if 1 ≤ k.gam then k.cols ++ [f.tcode] else k.cols), WFcol f.c p := by
    intro p hp; split at hp
    · rcases List.mem_append.1 hp with h | h
      · exact hwA p h
      · rw [List.mem_singleton.1 h]; exact hwT
    · exact hwA p hp
  intro e he
  unfold ngSuccsP at he
  simp only [List.mem_append, List.mem_flatMap, List.mem_map] at he
  rcases he with ((h | h) | h) | h
  · obtain ⟨a, ha, b, hb, rfl⟩ := h
    exact hW _ ⟨hwA, WF_cmpFl hf a b⟩
  · obtain ⟨d, hd, s, hs, cd, _, h⟩ := h
    have hwM := WF_merge_cond hf cd k.fl d s (hwA d hd) (hwS s hs)
    split at h
    · simp at h
    · simp only [List.mem_cons, List.mem_nil_iff, or_false] at h
      rcases h with rfl | rfl
      · refine hW _ ⟨fun p hp => ?_, hk.2⟩
        rcases List.mem_cons.1 hp with h | h
        · rw [h]; exact hwM
        · exact wf_erase hf hwA p h
      · refine hW _ ⟨fun p hp => ?_, hk.2⟩
        rcases List.mem_cons.1 hp with h | h
        · rw [h]; exact hwM
        · exact hwA p h
  · split at h
    · simp only [List.mem_flatMap] at h
      obtain ⟨s, hs, cd, _, h⟩ := h
      have hwM := WF_merge_cond hf cd k.fl f.tcode s hwT (hwA s hs)
      split at h
      · simp at h
      · simp only [List.mem_cons, List.mem_nil_iff, or_false] at h
        subst h
        refine hW _ ⟨fun p hp => ?_, hk.2⟩
        rcases List.mem_cons.1 hp with h | h
        · rw [h]; exact hwM
        · exact hwA p h
    · simp at h
  · split at h
    · simp only [List.mem_cons, List.mem_nil_iff, or_false] at h
      subst h; exact hW _ ⟨hwA, hk.2⟩
    · simp at h

theorem maxCoverB_mono (k : Key) {b b' : Nat} (h : b ≤ b') : maxCoverB f.c k b ≤ maxCoverB f.c k b' := by
  simp only [maxCoverB]
  apply maxList_map_le
  intro j _
  exact coverFrom_mono f.c _ j _ _ 0 (by omega)

theorem canonWith_cands (k : PKey) : canonWith f (candsP f k.fl) k = canonP f k := rfl

theorem fastOKP2_sound (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m))
    (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (lookF : PKey → Option Nat) (lookS : Key → Option Nat) (hlk : ∀ kc, WFkey f.c kc → lookS (decodeK f.c kc) = lookF kc)
    (KB Gc : Nat) (k0 : PKey) (hk0 : WFkey f.c k0) (h : fastOKP2 f (candsP f k0.fl) KB Gc lookF k0 = true) :
    fastOK f.c (group f.c) KB Gc lookS (decodeK f.c k0) = true := by
  have hu : ∀ k : PKey, (undone f.c (decodeK f.c k)).length = (undoneP f k).length := fun _ => rfl
  obtain ⟨hcan, hwc⟩ := decode_canonP hf hcx hgo k0 hk0
  unfold fastOKP2 at h
  rw [canonWith_cands hf hcx] at h
  unfold fastOK succOKG
  rw [hu, deadP_eq hf k0 hk0.1 |>.symm, ← hcan, hlk _ hwc]
  simp only [Bool.or_eq_true] at h ⊢
  rcases h with (h | h) | h | h
  · exact Or.inl (Or.inl h)
  · exact Or.inl (Or.inr h)
  · exact Or.inr (Or.inl (Or.inl h))
  · refine Or.inr (Or.inr ?_)
    unfold hPrune at h
    dsimp only at h
    rw [hcP2_eq_of_inv5 (hf := hf) (hinv5 := hinv5), maxCoverBP_eq f hf _ hwc.1] at h
    simp only [hB, hu, Bool.or_eq_true, decide_eq_true_eq] at h ⊢
    have hm := maxCoverB_mono hf hcx (decodeK f.c (canonP f k0))
      (show KB + 3 - Gc - hc f.c (decodeK f.c (canonP f k0)) - (undoneP f (canonP f k0)).length ≤ KB + 3 - Gc by omega)
    rcases h with h | h <;> omega

theorem stateOKP2_sound (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m))
    (hinv5 : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 < 5)
    (lookF : PKey → Option Nat) (lookS : Key → Option Nat) (hlk : ∀ kc, WFkey f.c kc → lookS (decodeK f.c kc) = lookF kc)
    (cs : List Cond) (KB : Nat) (k : PKey) (g : Nat) (hk : WFkey f.c k) (h : stateOKP2 f cs KB lookF k g = true) :
    (!isGoal f.c (decodeK f.c k) &&
      (ngSuccs f.c cs (decodeK f.c k)).all fun (k', w) => fastOK f.c (group f.c) KB (g + w) lookS k') = true := by
  unfold stateOKP2 at h
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
  exact fastOKP2_sound hf hcx hgo hinv5 lookF lookS hlk KB (g + e.2) e.1 hwe h2

end

end LeanReflect.FP
