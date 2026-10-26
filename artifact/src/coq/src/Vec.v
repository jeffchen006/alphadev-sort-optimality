(* Vec.v -- the column ("vector") machine used by the checker, and its link to Machine.v.
   A vector state runs the machine on W representative inputs at once.
   cols s = one column per register r < R; column entry w = value of register r on input w.
   Values are nat: input value = rank, T = n.  flags s = one flag per input w.
   dn s = done mask of the snapshot outputs (MODEL.md 4.3 M_out); the machine steps do not change it.
   Theorem relaxed_snap_cols: for a RelaxedSnap program, the snapshot register of output j holds the
   target column tgt j at the snapshot time.
   No order-type lemma is needed: the lower bound only uses "correct for all inputs ->
   correct for these W inputs". *)
From Stdlib Require Import ZArith List Bool Sorted Permutation Lia Arith Mergesort.
From CmovSort Require Import Machine.
Import ListNotations.

Definition col := list nat.
Record vst := VS { cols : list col; flags : list comparison; dn : list bool }.

Fixpoint setn {A} (l : list A) (i : nat) (v : A) : list A :=
  match l, i with
  | [], _ => []
  | _ :: t, 0 => v :: t
  | h :: t, S i' => h :: setn t i' v
  end.

Fixpoint blend (c : cond) (fl : list comparison) (xd xs : col) : col :=
  match fl, xd, xs with
  | f :: fl', a :: xd', b :: xs' => (if cond_eval c f then b else a) :: blend c fl' xd' xs'
  | _, _, _ => []
  end.

Fixpoint cmpcol (xa xb : col) : list comparison :=
  match xa, xb with
  | a :: xa', b :: xb' => Nat.compare a b :: cmpcol xa' xb'
  | _, _ => []
  end.

Definition getc (s : vst) (r : nat) : col := nth r (cols s) [].

Definition vstep (s : vst) (i : instr) : vst :=
  match i with
  | Mov d r => VS (setn (cols s) d (getc s r)) (flags s) (dn s)
  | Cmp a b => VS (cols s) (cmpcol (getc s a) (getc s b)) (dn s)
  | Cmov c d r => VS (setn (cols s) d (blend c (flags s) (getc s d) (getc s r))) (flags s) (dn s)
  end.

Definition vrun (p : program) (s : vst) : vst := fold_left vstep p s.

Definition vwf (R W : nat) (s : vst) : Prop :=
  length (cols s) = R /\ (forall c, In c (cols s) -> length c = W) /\ length (flags s) = W.

Definition instr_wf (R : nat) (i : instr) : Prop := forall r, In r (instr_regs i) -> r < R.

(* ---------- list lemmas ---------- *)
Lemma length_setn {A} (l : list A) i v : length (setn l i v) = length l.
Proof. revert i; induction l; intros [|i]; simpl; auto. Qed.

Lemma nth_setn {A} (l : list A) i v j d : i < length l ->
  nth j (setn l i v) d = if Nat.eqb j i then v else nth j l d.
Proof.
  revert i j; induction l as [|h t IH]; intros i j Hi; simpl in *; [lia|].
  destruct i, j; simpl; auto. apply IH; lia.
Qed.

Lemma in_setn {A} (l : list A) i v x : In x (setn l i v) -> In x l \/ x = v.
Proof.
  revert i; induction l as [|h t IH]; intros [|i]; simpl; try tauto.
  - intros [H|H]; auto.
  - intros [H|H]; auto. destruct (IH i H); auto.
Qed.

Lemma blend_len c fl xd xs W : length fl = W -> length xd = W -> length xs = W ->
  length (blend c fl xd xs) = W.
Proof.
  revert xd xs W; induction fl; intros [|] [|] [|W]; simpl; intros; try lia.
  f_equal; apply IHfl; lia.
Qed.

Lemma blend_nth c fl xd xs w : w < length fl -> w < length xd -> w < length xs ->
  nth w (blend c fl xd xs) 0 = if cond_eval c (nth w fl Eq) then nth w xs 0 else nth w xd 0.
Proof.
  revert xd xs w; induction fl; intros [|] [|] [|w]; simpl; intros; try lia; auto.
  apply IHfl; lia.
Qed.

Lemma cmpcol_len xa xb W : length xa = W -> length xb = W -> length (cmpcol xa xb) = W.
Proof. revert xb W; induction xa; intros [|] [|W]; simpl; intros; try lia. f_equal; apply IHxa; lia. Qed.

Lemma cmpcol_nth xa xb w : w < length xa -> w < length xb ->
  nth w (cmpcol xa xb) Eq = Nat.compare (nth w xa 0) (nth w xb 0).
Proof. revert xb w; induction xa; intros [|] [|w]; simpl; intros; try lia; auto. apply IHxa; lia. Qed.

Lemma getc_len R W s r : vwf R W s -> r < R -> length (getc s r) = W.
Proof. intros [H1 [H2 _]] Hr. apply H2. unfold getc. apply nth_In. lia. Qed.

Lemma vwf_step R W s i : vwf R W s -> instr_wf R i -> vwf R W (vstep s i).
Proof.
  intros Hs Hi. pose proof Hs as [H1 [H2 H3]].
  assert (L : forall r, r < R -> length (getc s r) = W) by (intros; eapply getc_len; eauto).
  unfold instr_wf in Hi.
  destruct i as [d r|a b|c d r]; simpl in Hi.
  - assert (r < R) by auto.
    split; [|split]; simpl; auto. now rewrite length_setn.
    intros x Hx. destruct (in_setn _ _ _ _ Hx); [auto|subst x]. auto.
  - assert (a < R) by auto. assert (b < R) by auto.
    split; [|split]; simpl; auto. apply cmpcol_len; auto.
  - assert (d < R) by auto. assert (r < R) by auto.
    split; [|split]; simpl; auto. now rewrite length_setn.
    intros x Hx. destruct (in_setn _ _ _ _ Hx); [auto|subst x].
    apply blend_len; auto.
Qed.

Definition prog_ok (iset : cond -> bool) (R : nat) (p : program) : Prop :=
  forall i, In i p -> instr_wf R i /\ instr_in iset i = true.

Lemma vwf_run R W p s : vwf R W s -> (forall i, In i p -> instr_wf R i) -> vwf R W (vrun p s).
Proof.
  revert s; induction p; simpl; intros; auto.
  apply IHp; auto. apply vwf_step; auto.
Qed.

(* ---------- row relation: column machine row w = concrete machine on input w ---------- *)
Definition rel (R : nat) (s : vst) (w : nat) (c : state Z) : Prop :=
  (forall r, r < R -> regs c r = Z.of_nat (nth w (getc s r) 0)) /\ flag c = nth w (flags s) Eq.

Lemma rel_step R W s w c i : vwf R W s -> w < W -> instr_wf R i -> rel R s w c ->
  rel R (vstep s i) w (step Z.compare c i).
Proof.
  intros Hs Hw Hi [Hr Hf]. pose proof Hs as [H1 [H2 H3]].
  assert (L : forall r, r < R -> length (getc s r) = W) by (intros; eapply getc_len; eauto).
  destruct i as [d r|a b|cd d r]; unfold instr_wf in Hi; simpl in Hi.
  - assert (d < R) by auto. assert (r < R) by auto.
    split; simpl; auto. intros r' Hr'. unfold getc at 1; simpl.
    rewrite nth_setn by lia. unfold upd. destruct (Nat.eqb r' d); auto.
  - assert (a < R) by auto. assert (b < R) by auto.
    split; simpl; auto. rewrite cmpcol_nth by (rewrite L; auto).
    rewrite !Hr by auto. apply Nat2Z.inj_compare.
  - assert (d < R) by auto. assert (r < R) by auto.
    simpl. rewrite Hf.
    destruct (cond_eval cd (nth w (flags s) Eq)) eqn:E.
    + split; simpl; auto. intros r' Hr'. unfold getc at 1; simpl.
      rewrite nth_setn by lia. unfold upd. destruct (Nat.eqb_spec r' d); auto.
      rewrite blend_nth by (rewrite ?L, ?H3; auto). rewrite E. auto.
    + split; simpl; auto. intros r' Hr'. unfold getc at 1; simpl.
      rewrite nth_setn by lia. destruct (Nat.eqb_spec r' d); auto. subst.
      rewrite blend_nth by (rewrite ?L, ?H3; auto). rewrite E. auto.
Qed.

Lemma rel_run R W p s w c : vwf R W s -> w < W -> (forall i, In i p -> instr_wf R i) ->
  rel R s w c -> rel R (vrun p s) w (run Z.compare p c).
Proof.
  revert s c; induction p; simpl; intros; auto.
  apply IHp; auto. apply vwf_step; auto. apply (rel_step R W); auto.
Qed.

(* ---------- initial state and goal ---------- *)
Definition vinit (n R : nat) (reps : list (list nat)) : vst :=
  VS (map (fun r => if Nat.ltb r n then map (fun rep => nth r rep 0) reps else repeat n (length reps))
          (seq 0 R))
     (repeat Eq (length reps)) (repeat false n).

Definition tgt (reps : list (list nat)) (j : nat) : col :=
  map (fun rep => nth j (NatSort.sort rep) 0) reps.

Definition reps_ok (n : nat) (reps : list (list nat)) : Prop :=
  forall rep, In rep reps -> length rep = n /\ (forall v, In v rep -> v < n).

Lemma vwf_init n R reps : vwf R (length reps) (vinit n R reps).
Proof.
  split; [|split]; simpl.
  - now rewrite length_map, length_seq.
  - intros c Hc. apply in_map_iff in Hc as [r [<- _]].
    destruct (Nat.ltb r n). now rewrite length_map. now rewrite repeat_length.
  - now rewrite repeat_length.
Qed.

Lemma nth_map_lt {A B} (f : A -> B) l i d d' : i < length l -> nth i (map f l) d = f (nth i l d').
Proof. revert i; induction l; intros [|i]; simpl; intros; try lia; auto. apply IHl; lia. Qed.

Lemma map_nth_seq (l : list nat) n : length l = n -> map (fun i => nth i l 0) (seq 0 n) = l.
Proof.
  intros H. apply nth_ext with (d := 0) (d' := 0).
  - now rewrite length_map, length_seq.
  - intros i Hi. rewrite length_map, length_seq in Hi.
    rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; lia).
    rewrite seq_nth by lia. reflexivity.
Qed.

Lemma sorted_map_Z (l : list nat) :
  Sorted (fun x y => is_true (x <=? y)) l -> Sorted Z.le (map Z.of_nat l).
Proof.
  induction 1 as [|a l Hs IH Hh]; simpl; constructor; auto.
  destruct Hh; simpl; constructor. apply Nat.leb_le in H. lia.
Qed.

Lemma sorted_perm_unique (l1 l2 : list Z) :
  Sorted Z.le l1 -> Sorted Z.le l2 -> Permutation l1 l2 -> l1 = l2.
Proof.
  intros H1 H2 P.
  apply Sorted_StronglySorted in H1; [|intros ???; lia].
  apply Sorted_StronglySorted in H2; [|intros ???; lia].
  revert l2 H2 P; induction H1 as [|a l1 S1 IH F1]; intros l2 H2 P.
  - symmetry. now apply Permutation_nil.
  - destruct H2 as [|b l2 S2 F2].
    + apply Permutation_sym, Permutation_nil in P. discriminate.
    + assert (a = b).
      { assert (Ha : In a (b :: l2)) by (eapply Permutation_in; eauto; left; auto).
        assert (Hb : In b (a :: l1)) by (eapply Permutation_in; [apply Permutation_sym; eauto|left; auto]).
        destruct Ha as [Ha|Ha]; auto. destruct Hb as [Hb|Hb]; auto.
        rewrite Forall_forall in F1, F2. specialize (F1 b Hb). specialize (F2 a Ha). lia. }
      subst. f_equal. apply IH; auto. eapply Permutation_cons_inv; eauto.
Qed.

Lemma run_untouched R p c r : (forall i, In i p -> instr_wf R i) -> R <= r ->
  regs (run Z.compare p c) r = regs c r.
Proof.
  revert c; induction p as [|i p IH]; simpl; intros c Hp Hr; auto.
  rewrite IH; auto. assert (Hi : instr_wf R i) by auto. unfold instr_wf in Hi.
  destruct i as [d s0|a b|cd d s0]; simpl in *; auto.
  - unfold upd. destruct (Nat.eqb_spec r d); auto. subst. specialize (Hi d (or_introl eq_refl)). lia.
  - destruct (cond_eval cd (flag c)); simpl; auto.
    unfold upd. destruct (Nat.eqb_spec r d); auto. subst. specialize (Hi d (or_introl eq_refl)). lia.
Qed.

Lemma in_firstn' {A} (x : A) t l : In x (firstn t l) -> In x l.
Proof. revert l; induction t; intros [|a l]; simpl; try tauto. intros [H|H]; auto. Qed.

Lemma firstn_wf R p t : (forall i, In i p -> instr_wf R i) -> forall i, In i (firstn t p) -> instr_wf R i.
Proof. intros H i Hi. apply H. eapply in_firstn'; eauto. Qed.

(* A snapshot register >= R is never written, so it holds T: not a correct output. *)
Lemma snap_reg_lt n R p o : 1 <= n -> n <= R -> RelaxedSnap n p o -> (forall i, In i p -> instr_wf R i) ->
  forall j, j < n -> fst (o j) < R.
Proof.
  intros H1 HnR Hc Hp j Hj. destruct (Nat.lt_ge_cases (fst (o j)) R) as [|Hge]; auto. exfalso.
  destruct (Hc (fun _ => 0%Z) 1%Z) as [_ Hperm]; [intros; lia|].
  assert (Hin : In (snapOut p o (relaxInit n (fun _ => 0%Z) 1%Z) j) (outs n (fun _ => 0%Z))).
  { eapply Permutation_in; [apply Permutation_sym, Hperm|]. unfold outs. apply in_map, in_seq. lia. }
  unfold snapOut in Hin. rewrite run_untouched with (R := R) in Hin; auto; [|apply firstn_wf; auto].
  simpl in Hin. destruct (Nat.ltb_spec (fst (o j)) n); [lia|].
  unfold outs in Hin. apply in_map_iff in Hin as [? [E _]]. discriminate.
Qed.

Theorem relaxed_snap_cols n R reps p o :
  n <= R -> reps_ok n reps -> RelaxedSnap n p o -> (forall i, In i p -> instr_wf R i) ->
  forall j, j < n -> fst (o j) < R ->
  getc (vrun (firstn (snd (o j)) p) (vinit n R reps)) (fst (o j)) = tgt reps j.
Proof.
  intros HnR Hreps Hc Hp j Hj HrR.
  set (W := length reps). set (q := firstn (snd (o j)) p).
  assert (Hq : forall i, In i q -> instr_wf R i) by (apply firstn_wf; auto).
  assert (Hwf : vwf R W (vrun q (vinit n R reps))) by (apply vwf_run; auto; apply vwf_init).
  apply nth_ext with (d := 0) (d' := 0).
  - rewrite (getc_len R W) by auto. unfold tgt. now rewrite length_map.
  - intros w Hw. rewrite (getc_len R W) in Hw by auto.
    set (rep := nth w reps []).
    assert (Hrep : length rep = n /\ (forall v, In v rep -> v < n)) by (apply Hreps, nth_In; auto).
    set (x := fun i => Z.of_nat (nth i rep 0)).
    set (T := Z.of_nat n).
    assert (HxT : forall i, i < n -> (x i < T)%Z).
    { intros i Hi. unfold x, T. apply Nat2Z.inj_lt. apply Hrep. apply nth_In. lia. }
    assert (Hrel0 : rel R (vinit n R reps) w (relaxInit n x T)).
    { split; simpl; [|unfold getc; simpl; now rewrite nth_repeat].
      intros r Hr. unfold getc. simpl.
      rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; lia).
      rewrite seq_nth by lia. simpl.
      destruct (Nat.ltb r n).
      - rewrite (nth_map_lt _ _ _ _ []) by auto. reflexivity.
      - unfold T. rewrite nth_indep with (d' := n) by (rewrite repeat_length; auto).
        now rewrite nth_repeat. }
    destruct (Hc x T HxT) as [Hs Hperm].
    assert (Hx : outs n x = map Z.of_nat rep).
    { unfold outs, x. transitivity (map Z.of_nat (map (fun i => nth i rep 0) (seq 0 n))).
      now rewrite map_map. rewrite map_nth_seq by apply Hrep. reflexivity. }
    set (y := snapOut p o (relaxInit n x T)) in *.
    assert (Hu : outs n y = map Z.of_nat (NatSort.sort rep)).
    { apply sorted_perm_unique; auto. apply sorted_map_Z, NatSort.Sorted_sort.
      eapply Permutation_trans; [apply Permutation_sym; exact Hperm|].
      rewrite Hx. apply Permutation_map, NatSort.Permuted_sort. }
    assert (E1 : nth j (outs n y) 0%Z = y j).
    { unfold outs. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
      rewrite seq_nth by auto. reflexivity. }
    rewrite Hu in E1.
    assert (Hrel : rel R (vrun q (vinit n R reps)) w (run Z.compare q (relaxInit n x T)))
      by (apply (rel_run R W); auto; apply vwf_init).
    unfold y, snapOut in E1. fold q in E1.
    rewrite (proj1 Hrel (fst (o j)) HrR) in E1.
    rewrite (nth_map_lt _ _ _ _ 0) in E1.
    2:{ rewrite <- (Permutation_length (NatSort.Permuted_sort rep)). lia. }
    apply Nat2Z.inj in E1.
    unfold tgt. rewrite (nth_map_lt _ _ _ _ []) by auto. fold rep. symmetry. exact E1.
Qed.
