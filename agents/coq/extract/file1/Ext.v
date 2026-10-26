From Stdlib Require Import List Extraction ExtrOcamlBasic ExtrOcamlNatInt ExtrOCamlInt63.
From CmovSort Require Import Machine Vec Good Prune Check SetModel Inst Sort3 SetList.
Extraction Blacklist List String Nat Int.
Extract Inlined Constant Nat.eqb => "(fun (x:int) (y:int) -> x = y)".
Extract Inlined Constant Nat.leb => "(fun (x:int) (y:int) -> x <= y)".
Extract Inlined Constant Nat.ltb => "(fun (x:int) (y:int) -> x < y)".
Extract Inlined Constant Init.Nat.eqb => "(fun (x:int) (y:int) -> x = y)".
Extract Inlined Constant Init.Nat.leb => "(fun (x:int) (y:int) -> x <= y)".
Extract Inlined Constant Init.Nat.ltb => "(fun (x:int) (y:int) -> x < y)".
(* untrusted helpers for the reader: build + canonicalize a state *)
Definition perms3 : list (list nat) := Eval vm_compute in lperms 3 reps3.
Definition mkst3 (cols : list (list nat)) (fl : list comparison) (dn : list bool) :=
  Lcanon reps3 perms3 (SS (map (lenc 3 reps3) cols) (lencf reps3 fl) dn).
Definition reps3_out := reps3.
(* the verified test (SetList.lower_bound_set') *)
Definition okfile3 (i1 : bool) V k := set_okb 3 reps3 tg3 strict3 (if i1 then cond_inI1 else cond_inI0) perms3 V k.
Definition mark3 := Lmark 3 reps3 tg3.
Definition build3 := Lbuild reps3.
Definition entry3 (i1 : bool) := Lentry 3 reps3 tg3 strict3 (if i1 then cond_inI1 else cond_inI0) perms3.
Definition markedb3 := Lmarkedb 3 reps3 tg3.
Definition root3 := Lroot 3 reps3 tg3 perms3.
Definition ops3 (i1 : bool) := Lops 3 reps3 (if i1 then cond_inI1 else cond_inI0).
Definition step3 := Lsstep 3 reps3 tg3.
Definition canon3 := Lcanon reps3 perms3.
Definition prune3 := Lprune 3 reps3 tg3 strict3.
Definition look3 := Llook reps3.
Definition dom3 := Ldom 3 reps3.
Definition cost3 := @cost (LC reps3).
Extraction "fcheck3.ml" mkst3 reps3_out okfile3 mark3 build3 entry3 markedb3 root3 ops3 step3 canon3 prune3 look3 dom3 cost3.
