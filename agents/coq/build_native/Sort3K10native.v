(* k = 10 premise of Sort3.sort3_lb by native_compute (closed theorem; TCB adds the OCaml native compiler) *)
From CmovSort Require Import Machine Vec Inst Sort3.
Lemma sort3_ok10 : all_okb 3 13 reps3 tg3 strict3 cond_inI1 (V3 cond_inI1 10) 10 = true.
Proof. Time native_cast_no_check (eq_refl true). Time Qed.
Theorem sort3_lb10 : forall p o, length p <= 10 -> prog_ok cond_inI1 13 p -> ~ RelaxedSnap 3 p o.
Proof. apply (sort3_lb sort3_ok10). Qed.
Print Assumptions sort3_lb10.
