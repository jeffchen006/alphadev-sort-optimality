(* Sort4.v -- n = 4 instance data: the 24 strict order types. *)
From Stdlib Require Import List Bool Lia Arith Mergesort.
From CmovSort Require Import Machine Vec SetList.
Import ListNotations.

Definition reps4 : list (list nat) := Eval vm_compute in perms_of 4 (seq 0 4).
Definition strict4 : list nat := Eval vm_compute in seq 0 24.
Definition tg4 : list col := Eval vm_compute in map (tgt reps4) (seq 0 4).

Definition perms4 : list (list nat) := Eval vm_compute in lperms 4 reps4.
