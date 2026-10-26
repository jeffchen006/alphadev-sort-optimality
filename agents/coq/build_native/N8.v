From CmovSort Require Import Machine Vec Inst Sort3.
Time Lemma n8 : all_okb 3 11 reps3 tg3 strict3 cond_inI1 (V3 cond_inI1 8) 8 = true.
Proof. Time native_cast_no_check (eq_refl true). Time Qed.
Time Lemma n9 : all_okb 3 12 reps3 tg3 strict3 cond_inI1 (V3 cond_inI1 9) 9 = true.
Proof. Time native_cast_no_check (eq_refl true). Time Qed.
Print Assumptions n9.
