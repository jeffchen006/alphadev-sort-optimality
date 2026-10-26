(* Sort3.v -- sort3 instance data. *)
From Stdlib Require Import List Bool Lia Arith Mergesort.
From CmovSort Require Import Machine Vec Good Prune Check Sound Inst.
Import ListNotations.

(* the 6 strict order types of 3 inputs (rank vectors) *)
Definition reps3 : list (list nat) := [[0;1;2];[0;2;1];[1;0;2];[1;2;0];[2;0;1];[2;1;0]].
Definition strict3 : list nat := [0;1;2;3;4;5].
Definition tg3 : list col := Eval vm_compute in map (tgt reps3) (seq 0 3).
