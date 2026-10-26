From Stdlib Require Import List Extraction ExtrOcamlBasic ExtrOcamlNatInt ExtrOCamlInt63.
From CmovSort Require Import Machine Vec Good Prune Check Sound Inst Sort3.
Extraction Blacklist List String Nat Int.
(* typed realizations of nat comparisons (nat = OCaml int via ExtrOcamlNatInt); part of the trust base *)
Extract Inlined Constant Nat.eqb => "(fun (x:int) (y:int) -> x = y)".
Extract Inlined Constant Nat.leb => "(fun (x:int) (y:int) -> x <= y)".
Extract Inlined Constant Nat.ltb => "(fun (x:int) (y:int) -> x < y)".
Extract Inlined Constant Nat.compare => "(fun (x:int) (y:int) -> if x = y then Eq else if x < y then Lt else Gt)".
Extract Inlined Constant Init.Nat.compare => "(fun (x:int) (y:int) -> if x = y then Eq else if x < y then Lt else Gt)".
Extract Inlined Constant Init.Nat.eqb => "(fun (x:int) (y:int) -> x = y)".
Extract Inlined Constant Init.Nat.leb => "(fun (x:int) (y:int) -> x <= y)".
Extract Inlined Constant Init.Nat.ltb => "(fun (x:int) (y:int) -> x < y)".

Definition iset_of (b : bool) : cond -> bool := if b then cond_inI1 else cond_inI0.
Definition cert3 (i1 : bool) (k : nat) := search 3 (3 + k) reps3 tg3 strict3 (iset_of i1) k.
Definition pre3 (i1 : bool) (k : nat) (V : list (vst * nat)) : bool :=
  pre_okb 3 (3 + k) reps3 tg3 strict3 (iset_of i1) V k.
Definition table3 (V : list (vst * nat)) := build V.
Definition chunk3 (i1 : bool) (k : nat) (m : tbl) (V : list (vst * nat)) (N i : nat) : bool :=
  check_from 3 (3 + k) reps3 tg3 strict3 (iset_of i1) m N i 0 V.
Extraction "check3.ml" cert3 pre3 table3 chunk3.
