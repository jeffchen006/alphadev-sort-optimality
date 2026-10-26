(* Inst.v -- boolean tests for the instance hypotheses of Sound.certifies_sound. *)
From Stdlib Require Import List Bool Lia Arith Mergesort.
From CmovSort Require Import Machine Vec Good Prune Check Sound.
Import ListNotations.

Fixpoint nodupb (l : list nat) : bool :=
  match l with [] => true | x :: t => negb (existsb (Nat.eqb x) t) && nodupb t end.

Lemma nodupb_spec l : nodupb l = true -> NoDup l.
Proof.
  induction l as [|x t IH]; simpl; intros H; constructor.
  - apply andb_true_iff in H as [H _]. apply negb_true_iff in H. intros Hin.
    assert (existsb (Nat.eqb x) t = true) by (apply existsb_exists; exists x; split; auto; apply Nat.eqb_refl).
    congruence.
  - apply andb_true_iff in H as [_ H]. auto.
Qed.

Definition reps_okb (n : nat) (reps : list (list nat)) : bool :=
  forallb (fun rep => Nat.eqb (length rep) n && forallb (fun v => Nat.ltb v n) rep) reps.

Lemma reps_okb_spec n reps : reps_okb n reps = true -> reps_ok n reps.
Proof.
  unfold reps_okb, reps_ok. rewrite forallb_forall. intros H rep Hr.
  specialize (H rep Hr). apply andb_true_iff in H as [H1 H2]. apply Nat.eqb_eq in H1.
  rewrite forallb_forall in H2. split; auto. intros v Hv. apply Nat.ltb_lt; auto.
Qed.

Definition strict_okb (n : nat) (reps : list (list nat)) (strict : list nat) : bool :=
  forallb (fun w => Nat.ltb w (length reps) && nodupb (nth w reps [])
                    && col_eqb (NatSort.sort (nth w reps [])) (seq 0 n)) strict
  && nodupb strict
  && forallb (fun w1 => forallb (fun w2 => implb (col_eqb (nth w1 reps []) (nth w2 reps [])) (Nat.eqb w1 w2))
                                strict) strict.

Lemma strict_okb_spec n reps strict : strict_okb n reps strict = true ->
  (forall w, In w strict -> w < length reps /\ NoDup (nth w reps []) /\ NatSort.sort (nth w reps []) = seq 0 n) /\
  (forall w1 w2, In w1 strict -> In w2 strict -> nth w1 reps [] = nth w2 reps [] -> w1 = w2) /\
  NoDup strict.
Proof.
  unfold strict_okb. intros H. apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  rewrite forallb_forall in H1, H3. split; [|split].
  - intros w Hw. specialize (H1 w Hw). apply andb_true_iff in H1 as [H1 Hs].
    apply andb_true_iff in H1 as [Hl Hn]. apply Nat.ltb_lt in Hl. apply nodupb_spec in Hn.
    apply col_eqb_spec in Hs. auto.
  - intros w1 w2 I1 I2 E. specialize (H3 w1 I1). rewrite forallb_forall in H3. specialize (H3 w2 I2).
    assert (col_eqb (nth w1 reps []) (nth w2 reps []) = true) by (apply col_eqb_spec; auto).
    rewrite H in H3. simpl in H3. apply Nat.eqb_eq; auto.
  - apply nodupb_spec; auto.
Qed.

Definition tg_okb (n : nat) (reps : list (list nat)) (tg : list col) : bool :=
  forallb (fun j => col_eqb (nth j tg []) (tgt reps j)) (seq 0 n).

Lemma tg_okb_spec n reps tg : tg_okb n reps tg = true -> forall j, j < n -> nth j tg [] = tgt reps j.
Proof.
  unfold tg_okb. rewrite forallb_forall. intros H j Hj. apply (proj1 (col_eqb_spec _ _)). apply H, in_seq. lia.
Qed.

(* All hypotheses + the certificate in one boolean. *)
Definition all_okb n R reps tg strict V k : bool :=
  Nat.leb n R && reps_okb n reps && tg_okb n reps tg && strict_okb n reps strict
  && certifies n R reps tg strict V k.

Theorem lower_bound n R reps tg strict V k : all_okb n R reps tg strict V k = true ->
  forall p, length p <= k -> prog_ok R p -> ~ RelaxedCorrect n p.
Proof.
  unfold all_okb. intros H. repeat (apply andb_true_iff in H as [H ?]).
  apply Nat.leb_le in H. apply reps_okb_spec in H3. pose proof (tg_okb_spec _ _ _ H2) as H2t.
  destruct (strict_okb_spec _ _ _ H1) as [A [B C]].
  apply (certifies_sound n R reps tg strict H H3 H2t A B C V k H0).
Qed.
