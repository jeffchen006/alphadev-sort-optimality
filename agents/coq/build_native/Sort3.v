(* Sort3.v -- sort3 instance data. *)
From Stdlib Require Import List Bool Lia Arith Mergesort.
From CmovSort Require Import Machine Vec Good Prune Check Sound Inst.
Import ListNotations.

(* the 6 strict order types of 3 inputs (rank vectors) *)
Definition reps3 : list (list nat) := [[0;1;2];[0;2;1];[1;0;2];[1;2;0];[2;0;1];[2;1;0]].
Definition strict3 : list nat := [0;1;2;3;4;5].
Definition tg3 : list col := Eval vm_compute in map (tgt reps3) (seq 0 3).

Definition V3 (iset : cond -> bool) (k : nat) := search 3 (3 + k) reps3 tg3 strict3 iset k.

(* The premise is the boolean that extract/v4 (OCaml) evaluates to true; see run_sort3.sh. *)
Theorem sort3_lb (H : all_okb 3 13 reps3 tg3 strict3 cond_inI1 (V3 cond_inI1 10) 10 = true) :
  forall p o, length p <= 10 -> prog_ok cond_inI1 13 p -> ~ RelaxedSnap 3 p o.
Proof. apply (lower_bound _ _ _ _ _ _ _ _ H). Qed.

Theorem sort3_lb_strict (H : all_okb 3 13 reps3 tg3 strict3 cond_inI1 (V3 cond_inI1 10) 10 = true) :
  forall p o, length p <= 10 -> prog_ok cond_inI1 13 p -> ~ StrictSnap 3 p o.
Proof. apply (lower_bound_strict _ _ _ _ _ _ _ _ H). Qed.

(* sanity: k = 8 as a closed theorem by the kernel VM (about 30 s) *)
Lemma sort3_ok8 : all_okb 3 11 reps3 tg3 strict3 cond_inI1 (V3 cond_inI1 8) 8 = true.
Proof. vm_cast_no_check (eq_refl true). Qed.
Theorem sort3_lb8 : forall p o, length p <= 8 -> prog_ok cond_inI1 11 p -> ~ RelaxedSnap 3 p o.
Proof. apply (lower_bound _ _ _ _ _ _ _ _ sort3_ok8). Qed.

Print Assumptions sort3_lb.
Print Assumptions sort3_lb8.
