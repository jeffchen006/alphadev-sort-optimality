From Stdlib Require Import List Extraction ExtrOcamlBasic ExtrOcamlNatInt ExtrOCamlInt63.
From CmovSort Require Import Machine Vec Good Prune Check SetModel Inst Sort3 Sort4 SetList.
Extraction Blacklist List String Nat Int.
Extract Inlined Constant Nat.eqb => "(fun (x:int) (y:int) -> x = y)".
Extract Inlined Constant Nat.leb => "(fun (x:int) (y:int) -> x <= y)".
Extract Inlined Constant Nat.ltb => "(fun (x:int) (y:int) -> x < y)".
Extract Inlined Constant Init.Nat.eqb => "(fun (x:int) (y:int) -> x = y)".
Extract Inlined Constant Init.Nat.leb => "(fun (x:int) (y:int) -> x <= y)".
Extract Inlined Constant Init.Nat.ltb => "(fun (x:int) (y:int) -> x < y)".
Definition iset_of (b : bool) : cond -> bool := if b then cond_inI1 else cond_inI0.
Definition scert3 (i1 : bool) (k : nat) := ssearch 4 reps4 tg4 strict4 (iset_of i1) perms4 k.
Definition sok3 (i1 : bool) (k : nat) V := set_okb 4 reps4 tg4 strict4 (iset_of i1) perms4 V k.
Extraction "scheck3.ml" scert3 sok3.
