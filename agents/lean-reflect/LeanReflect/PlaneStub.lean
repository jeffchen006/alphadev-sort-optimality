import LeanReflect.PlaneDefs
import LeanReflect.Lemmas
/- TEMPORARY stub of PlaneBits/PlaneHc statements (sorry) so that PlaneMain can be developed. NOT used in results. -/
namespace LeanReflect.FP
open SortProof LeanReflect
variable {f : FC}
theorem laneVal_eq (hf : FCOK f) (p : PCol) (t : Nat) (ht : t < 32) : laneVal f p t = laneValS f.c.n p t := sorry
theorem WF_merge (hf : FCOK f) (C : UInt64) (d s : PCol) (hd : WFcol f.c d) (hs : WFcol f.c s) : WFcol f.c (merge C d s) := sorry
theorem decode_merge (hf : FCOK f) (cd : Cond) (fl : UInt64) (hfl : WFfl f.c fl) (d s : PCol) :
    decodeCol f.c (merge (condMask f cd fl) d s) = LeanReflect.merge cd (decodeFl f.c fl) (decodeCol f.c d) (decodeCol f.c s) := sorry
theorem WF_cmpFl (hf : FCOK f) (a b : PCol) : WFfl f.c (cmpFl f a b) := sorry
theorem decode_cmpFl (hf : FCOK f) (a b : PCol) (ha : WFcol f.c a) (hb : WFcol f.c b) :
    decodeFl f.c (cmpFl f a b) = cmpCol (decodeCol f.c a) (decodeCol f.c b) := sorry
theorem WF_canonF (hf : FCOK f) (fl : UInt64) (h : WFfl f.c fl) : WFfl f.c (canonF fl) := sorry
theorem decode_canonF (hf : FCOK f) (fl : UInt64) (h : WFfl f.c fl) : decodeFl f.c (canonF fl) = LeanReflect.canonF (decodeFl f.c fl) := sorry
theorem WF_permCol (hf : FCOK f) {π : List Nat} (hπ : π.Perm (List.range f.c.m)) (p : PCol) (hp : WFcol f.c p) :
    WFcol f.c (permCol (mkTab π) p) := sorry
theorem decode_permCol (hf : FCOK f) {π : List Nat} (hπ : π.Perm (List.range f.c.m)) (p : PCol) (hp : WFcol f.c p) :
    decodeCol f.c (permCol (mkTab π) p) = LeanReflect.permCol π (decodeCol f.c p) := sorry
theorem WF_permFl (hf : FCOK f) {π : List Nat} (hπ : π.Perm (List.range f.c.m)) (fl : UInt64) (h : WFfl f.c fl) :
    WFfl f.c (permFl (mkTab π) fl) := sorry
theorem decode_permFl (hf : FCOK f) {π : List Nat} (hπ : π.Perm (List.range f.c.m)) (fl : UInt64) (h : WFfl f.c fl) :
    decodeFl f.c (permFl (mkTab π) fl) = permF π (decodeFl f.c fl) := sorry
theorem colNum_decode (hf : FCOK f) (p : PCol) (hp : WFcol f.c p) : colNum f.c (decodeCol f.c p) = numP p := sorry
theorem flagNum_decode (hf : FCOK f) (fl : UInt64) (h : WFfl f.c fl) : flagNum (decodeFl f.c fl) = fl.toNat := sorry
theorem pLt_iff (p q : PCol) : pLt p q = decide (numP p < numP q) := sorry
theorem decodeCol_inj (hf : FCOK f) {p q : PCol} (hp : WFcol f.c p) (hq : WFcol f.c q)
    (h : decodeCol f.c p = decodeCol f.c q) : p = q := sorry
theorem decodeFl_inj (hf : FCOK f) {a b : UInt64} (ha : WFfl f.c a) (hb : WFfl f.c b)
    (h : decodeFl f.c a = decodeFl f.c b) : a = b := sorry
theorem deadP_eq (hf : FCOK f) (k : PKey) (hk : ∀ p ∈ k.cols, WFcol f.c p) : deadP f k = dead f.c (decodeK f.c k) := sorry
theorem WF_tcode (hf : FCOK f) : WFcol f.c f.tcode := sorry
theorem decode_tcode (hf : FCOK f) (hT : f.c.T = List.replicate f.c.m (f.c.n : Int)) : decodeCol f.c f.tcode = f.c.T := sorry
theorem hcP2_eq (hf : FCOK f) (k : PKey) (hk : WFkey f.c k) : hcP2 f k = hc f.c (decodeK f.c k) := sorry
theorem maxCoverBP_eq (hf : FCOK f) (k : PKey) (hk : ∀ p ∈ k.cols, WFcol f.c p) (b : Nat) :
    maxCoverBP f k b = maxCoverB f.c (decodeK f.c k) b := sorry
end LeanReflect.FP
