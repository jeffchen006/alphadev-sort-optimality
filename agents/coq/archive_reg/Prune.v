(* Prune.v -- soundness of the three prune rules (same rules as agents/enum, see NOTES.md):
   dead : on some input w, some input value is in no register  -> never reaches the goal;
   hw   : number of outputs P_j whose column is not the target; each needs one non-cmp instruction;
   hc   : a class of G strict inputs with equal (flag, held input index per register)
          needs >= log2 |G| more cmp instructions (each cmp splits a class into <= 2 parts).
   Theorem prune_sound: prune s b = true -> ~ vgood s b. *)
From Stdlib Require Import List Bool Lia Arith ZArith Mergesort Permutation.
From CmovSort Require Import Machine Vec Good.
Import ListNotations.

Fixpoint col_eqb (a b : list nat) : bool :=
  match a, b with
  | [], [] => true
  | x :: a', y :: b' => Nat.eqb x y && col_eqb a' b'
  | _, _ => false
  end.

Lemma col_eqb_spec a b : col_eqb a b = true <-> a = b.
Proof.
  revert b; induction a; intros [|]; simpl; split; intros H; try discriminate; auto.
  - apply andb_true_iff in H as [H1 H2]. apply Nat.eqb_eq in H1. apply IHa in H2. now subst.
  - inversion H; subst. rewrite Nat.eqb_refl. simpl. now apply IHa.
Qed.

Definition isCmp (i : instr) : bool := match i with Cmp _ _ => true | _ => false end.
Definition ncmp (p : program) : nat := length (filter isCmp p).
Definition nnon (p : program) : nat := length (filter (fun i => negb (isCmp i)) p).

Lemma ncmp_nnon p : ncmp p + nnon p = length p.
Proof. unfold ncmp, nnon. induction p; simpl; auto. destruct (isCmp a); simpl; lia. Qed.

Section Prune.
Variables (n R : nat) (reps : list (list nat)).
Let W := length reps.
Hypothesis HnR : n <= R.
Hypothesis Hreps : reps_ok n reps.

Definition rowval (s : vst) (w r : nat) : nat := nth w (getc s r) 0.

Lemma rowval_mov s d src w r : vwf R W s -> d < R -> src < R ->
  rowval (vstep s (Mov d src)) w r = if Nat.eqb r d then rowval s w src else rowval s w r.
Proof.
  intros [L _] Hd Hs. unfold rowval. destruct s as [cs fs]; simpl in *.
  rewrite getc_setn by lia. destruct (Nat.eqb r d); auto.
Qed.

Lemma rowval_cmov s c d src w r : vwf R W s -> d < R -> src < R -> w < W ->
  rowval (vstep s (Cmov c d src)) w r =
  if Nat.eqb r d then (if cond_eval c (nth w (flags s) Eq) then rowval s w src else rowval s w d)
  else rowval s w r.
Proof.
  intros Hw Hd Hs Hww. pose proof Hw as [L [_ L3]].
  assert (Lc : forall r, r < R -> length (getc s r) = W) by (intros; eapply getc_len; eauto).
  unfold rowval. destruct s as [cs fs]; simpl in *.
  rewrite getc_setn by lia. destruct (Nat.eqb r d); auto.
  rewrite blend_nth; auto; simpl; rewrite ?Lc; auto; lia.
Qed.

Lemma rowval_cmp s a b w r : rowval (vstep s (Cmp a b)) w r = rowval s w r.
Proof. reflexivity. Qed.

Lemma flags_cmp s a b w : vwf R W s -> a < R -> b < R -> w < W ->
  nth w (flags (vstep s (Cmp a b))) Eq = Nat.compare (rowval s w a) (rowval s w b).
Proof.
  intros Hw Ha Hb Hww. simpl. apply cmpcol_nth; erewrite getc_len; eauto.
Qed.

(* ---------- dead ---------- *)
Definition absent (s : vst) (w v : nat) : Prop := forall r, r < R -> rowval s w r <> v.

Lemma absent_step s i w v : vwf R W s -> instr_wf R i -> w < W -> absent s w v -> absent (vstep s i) w v.
Proof.
  intros Hs Hi Hw Ha r Hr. unfold instr_wf in Hi.
  destruct i as [d src|a b|c d src]; simpl in Hi.
  - rewrite rowval_mov by auto. destruct (Nat.eqb r d); auto.
  - rewrite rowval_cmp. auto.
  - rewrite rowval_cmov by auto. destruct (Nat.eqb r d); auto.
    destruct (cond_eval _ _); apply Ha; auto.
Qed.

Lemma absent_run p s w v : vwf R W s -> (forall i, In i p -> instr_wf R i) -> w < W ->
  absent s w v -> absent (vrun p s) w v.
Proof.
  revert s; induction p; simpl; intros; auto.
  apply IHp; auto. apply vwf_step; auto. apply absent_step; auto.
Qed.

Lemma goal_row s w j : vgoal n reps s -> w < W -> j < n -> rowval s w j = nth j (NatSort.sort (nth w reps [])) 0.
Proof.
  intros Hg Hw Hj. unfold rowval. rewrite (Hg j Hj). unfold tgt.
  rewrite (nth_map_lt _ _ _ _ []) by auto. reflexivity.
Qed.

Lemma absent_goal s w v : w < W -> In v (nth w reps []) -> vgoal n reps s -> ~ absent s w v.
Proof.
  intros Hw Hv Hg Ha.
  set (rep := nth w reps []) in *.
  assert (Hl : length rep = n) by (apply Hreps, nth_In; auto).
  assert (Hin : In v (NatSort.sort rep)) by (eapply Permutation_in; [apply NatSort.Permuted_sort|auto]).
  apply In_nth with (d := 0) in Hin as [j [Hj Hjv]].
  rewrite <- (Permutation_length (NatSort.Permuted_sort rep)) in Hj.
  apply (Ha j); [lia|]. rewrite goal_row; auto; lia.
Qed.

Definition deadb (s : vst) : bool :=
  existsb (fun w => existsb (fun v => forallb (fun r => negb (Nat.eqb (rowval s w r) v)) (seq 0 R))
                            (nth w reps []))
          (seq 0 W).

Lemma deadb_sound s b : vwf R W s -> deadb s = true -> ~ vgood n R reps s b.
Proof.
  intros Hs Hd [p [_ [Hok Hg]]]. unfold deadb in Hd.
  apply existsb_exists in Hd as [w [Hw Hd]]. apply in_seq in Hw.
  apply existsb_exists in Hd as [v [Hv Hd]].
  assert (Ha : absent s w v).
  { intros r Hr. rewrite forallb_forall in Hd. specialize (Hd r).
    rewrite in_seq in Hd. specialize (Hd ltac:(lia)). apply negb_true_iff, Nat.eqb_neq in Hd. auto. }
  apply (absent_goal (vrun p s) w v); auto; [lia|].
  apply absent_run; auto; [intros; apply Hok; auto|lia].
Qed.

(* ---------- hw ---------- *)
Variable tg : list col.
Hypothesis Htg : forall j, j < n -> nth j tg [] = tgt reps j.

Definition hw (s : vst) : nat :=
  length (filter (fun j => negb (col_eqb (getc s j) (nth j tg []))) (seq 0 n)).

Lemma filter_notin (f g : nat -> bool) d l : ~ In d l -> (forall j, j <> d -> f j = g j) ->
  filter f l = filter g l.
Proof.
  intros Hd H. apply filter_ext_in. intros a Ha. apply H. intros ->. auto.
Qed.

Lemma filter_le_one (f g : nat -> bool) d l : NoDup l -> (forall j, j <> d -> f j = g j) ->
  length (filter f l) <= length (filter g l) + 1.
Proof.
  induction l as [|a l IH]; simpl; intros ND H; [lia|].
  inversion ND; subst.
  destruct (Nat.eq_dec a d) as [->|Ha].
  - rewrite (filter_notin f g d l) by auto. destruct (f d), (g d); simpl; lia.
  - rewrite (H a Ha). specialize (IH H3 H). destruct (g a); simpl; lia.
Qed.

Lemma hw_step s i : vwf R W s -> instr_wf R i ->
  hw s <= hw (vstep s i) + (if isCmp i then 0 else 1).
Proof.
  intros Hs Hi. unfold instr_wf in Hi. unfold hw.
  destruct i as [d src|a b|c d src]; simpl in Hi; simpl isCmp.
  - assert (d < R) by auto. pose proof Hs as [L _].
    apply (filter_le_one _ _ d); [apply seq_NoDup|].
    intros j Hj. destruct s as [cs fs]. simpl vstep. rewrite getc_setn by (simpl in L; lia).
    apply Nat.eqb_neq in Hj. now rewrite Hj.
  - rewrite Nat.add_0_r. reflexivity.
  - assert (d < R) by auto. pose proof Hs as [L _].
    apply (filter_le_one _ _ d); [apply seq_NoDup|].
    intros j Hj. destruct s as [cs fs]. simpl vstep. rewrite getc_setn by (simpl in L; lia).
    apply Nat.eqb_neq in Hj. now rewrite Hj.
Qed.

Lemma hw_goal s : vgoal n reps s -> hw s = 0.
Proof.
  intros Hg. unfold hw. rewrite (filter_ext_in _ (fun _ => false)).
  - clear. induction (seq 0 n); simpl; auto.
  - intros j Hj. apply in_seq in Hj. rewrite Hg, <- Htg by lia.
    assert (col_eqb (nth j tg []) (nth j tg []) = true) by (now apply col_eqb_spec).
    now rewrite H.
Qed.

Lemma hw_run p s : vwf R W s -> (forall i, In i p -> instr_wf R i) -> vgoal n reps (vrun p s) ->
  hw s <= nnon p.
Proof.
  revert s; induction p as [|i p IH]; simpl; intros s Hs Hp Hg.
  - rewrite hw_goal; auto.
  - unfold nnon in *. simpl.
    pose proof (hw_step s i Hs (Hp i (or_introl eq_refl))).
    assert (hw (vstep s i) <= length (filter (fun i => negb (isCmp i)) p)).
    { apply IH; auto. apply vwf_step; auto. }
    destruct (isCmp i); simpl; lia.
Qed.

(* ---------- hc ---------- *)
Fixpoint findpos (v : nat) (l : list nat) : nat :=
  match l with [] => S (n + v) | h :: t => if Nat.eqb h v then 0 else S (findpos v t) end.

Definition idx (w v : nat) : nat := if Nat.eqb v n then n else findpos v (nth w reps []).

Definition fcode (f : comparison) : nat := match f with Lt => 0 | Eq => 1 | Gt => 2 end.

Definition key (s : vst) (w : nat) : list nat :=
  fcode (nth w (flags s) Eq) :: map (fun r => idx w (rowval s w r)) (seq 0 R).

Lemma findpos_found v l : In v l -> findpos v l < length l /\ nth (findpos v l) l 0 = v.
Proof.
  induction l as [|h t IH]; simpl; [tauto|]. intros Hv.
  destruct (Nat.eqb_spec h v); simpl; [split; auto; lia|].
  destruct Hv as [->|Hv]; [tauto|]. destruct (IH Hv). split; auto; lia.
Qed.

Lemma findpos_notfound v l : ~ In v l -> findpos v l = length l + S (n + v).
Proof.
  induction l as [|h t IH]; simpl; auto. intros Hv.
  destruct (Nat.eqb_spec h v); [tauto|]. rewrite IH; auto.
Qed.

Lemma findpos_nodup l i : NoDup l -> i < length l -> findpos (nth i l 0) l = i.
Proof.
  revert i; induction l as [|h t IH]; simpl; intros i ND Hi; [lia|].
  inversion ND; subst. destruct i as [|i].
  - now rewrite Nat.eqb_refl.
  - destruct (Nat.eqb_spec h (nth i t 0)).
    + exfalso. apply H1. rewrite e. apply nth_In. lia.
    + f_equal. apply IH; auto. lia.
Qed.

Lemma findpos_cases v l : (In v l /\ findpos v l < length l /\ nth (findpos v l) l 0 = v) \/
                          (~ In v l /\ findpos v l = length l + S (n + v)).
Proof.
  destruct (in_dec Nat.eq_dec v l).
  - left. split; auto. apply findpos_found; auto.
  - right. split; auto. apply findpos_notfound; auto.
Qed.

Lemma idx_inj w v1 v2 : w < W -> idx w v1 = idx w v2 -> v1 = v2.
Proof.
  intros Hw. unfold idx.
  set (rep := nth w reps []).
  assert (Hr : length rep = n /\ (forall v, In v rep -> v < n)) by (apply Hreps, nth_In; auto).
  destruct Hr as [Hl Hv].
  destruct (Nat.eqb_spec v1 n), (Nat.eqb_spec v2 n); try congruence;
  [ destruct (findpos_cases v2 rep) as [[_ [A _]]|[_ A]]; lia
  | destruct (findpos_cases v1 rep) as [[_ [A _]]|[_ A]]; lia |].
  destruct (findpos_cases v1 rep) as [[I1 [A1 B1]]|[I1 A1]], (findpos_cases v2 rep) as [[I2 [A2 B2]]|[I2 A2]];
    intros E; try lia.
  - rewrite <- B1, <- B2, E. reflexivity.
Qed.

Definition ksim (s : vst) (w1 w2 : nat) : Prop :=
  nth w1 (flags s) Eq = nth w2 (flags s) Eq /\
  forall r, r < R -> idx w1 (rowval s w1 r) = idx w2 (rowval s w2 r).

Lemma fcode_inj f g : fcode f = fcode g -> f = g.
Proof. destruct f, g; simpl; congruence. Qed.

Lemma key_ksim s w1 w2 : key s w1 = key s w2 -> ksim s w1 w2.
Proof.
  unfold key. intros E. inversion E as [[E1 E2]]. split; [now apply fcode_inj|].
  intros r Hr.
  assert (A : forall w, nth r (map (fun r => idx w (rowval s w r)) (seq 0 R)) 0 = idx w (rowval s w r)).
  { intros w. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto). rewrite seq_nth; auto. }
  rewrite <- (A w1), <- (A w2). now rewrite E2.
Qed.

Lemma ksim_step s i w1 w2 : vwf R W s -> instr_wf R i -> w1 < W -> w2 < W -> ksim s w1 w2 ->
  (isCmp i = true -> (match nth w1 (flags (vstep s i)) Eq with Lt => true | _ => false end) =
                     (match nth w2 (flags (vstep s i)) Eq with Lt => true | _ => false end)) ->
  ksim (vstep s i) w1 w2.
Proof.
  intros Hs Hi H1 H2 [Kf Kr] Hb. unfold instr_wf in Hi.
  destruct i as [d src|a b|c d src]; simpl in Hi.
  - assert (d < R) by auto. assert (src < R) by auto.
    split; [exact Kf|]. intros r Hr. rewrite !rowval_mov by auto.
    destruct (Nat.eqb r d); auto.
  - assert (a < R) by auto. assert (b < R) by auto.
    specialize (Hb eq_refl). rewrite !flags_cmp in Hb by auto.
    split; [|intros r Hr; rewrite !rowval_cmp; auto].
    rewrite !flags_cmp by auto.
    assert (Ea : idx w1 (rowval s w1 a) = idx w2 (rowval s w2 a)) by auto.
    assert (Eb : idx w1 (rowval s w1 b) = idx w2 (rowval s w2 b)) by auto.
    assert (Iff : rowval s w1 a = rowval s w1 b <-> rowval s w2 a = rowval s w2 b).
    { split; intros E.
      - apply (idx_inj w2); auto. rewrite <- Ea, <- Eb, E. reflexivity.
      - apply (idx_inj w1); auto. rewrite Ea, Eb, E. reflexivity. }
    destruct (Nat.compare_spec (rowval s w1 a) (rowval s w1 b)),
             (Nat.compare_spec (rowval s w2 a) (rowval s w2 b)); auto; try discriminate;
      try (apply Iff in H3; lia); try (apply Iff in H4; lia).
  - assert (d < R) by auto. assert (src < R) by auto.
    split; [exact Kf|]. intros r Hr. rewrite !rowval_cmov by auto.
    destruct (Nat.eqb r d); auto. rewrite Kf. destruct (cond_eval _ _); auto.
Qed.

Fixpoint bits (p : program) (s : vst) (w : nat) : list bool :=
  match p with
  | [] => []
  | i :: p' =>
      if isCmp i then (match nth w (flags (vstep s i)) Eq with Lt => true | _ => false end)
                      :: bits p' (vstep s i) w
      else bits p' (vstep s i) w
  end.

Lemma bits_len p s w : length (bits p s w) = ncmp p.
Proof.
  unfold ncmp. revert s; induction p; simpl; intros; auto.
  destruct (isCmp a); simpl; auto.
Qed.

Lemma ksim_run p s w1 w2 : vwf R W s -> (forall i, In i p -> instr_wf R i) -> w1 < W -> w2 < W ->
  ksim s w1 w2 -> bits p s w1 = bits p s w2 -> ksim (vrun p s) w1 w2.
Proof.
  revert s; induction p as [|i p IH]; simpl; intros s Hs Hp H1 H2 K B; auto.
  assert (Hi : instr_wf R i) by auto.
  destruct (isCmp i) eqn:E.
  - inversion B as [[B1 B2]]. apply IH; auto. apply vwf_step; auto.
    apply ksim_step; auto.
  - apply IH; auto. apply vwf_step; auto. apply ksim_step; auto. congruence.
Qed.

Variable strict : list nat.
Hypothesis Hstrict : forall w, In w strict ->
  w < W /\ NoDup (nth w reps []) /\ NatSort.sort (nth w reps []) = seq 0 n.
Hypothesis Hsdist : forall w1 w2, In w1 strict -> In w2 strict -> nth w1 reps [] = nth w2 reps [] -> w1 = w2.
Hypothesis HsND : NoDup strict.

Lemma ksim_goal s w1 w2 : In w1 strict -> In w2 strict -> vgoal n reps s -> ksim s w1 w2 -> w1 = w2.
Proof.
  intros I1 I2 Hg [_ K].
  destruct (Hstrict w1 I1) as [W1 [N1 S1]]. destruct (Hstrict w2 I2) as [W2 [N2 S2]].
  apply Hsdist; auto.
  set (rep1 := nth w1 reps []) in *. set (rep2 := nth w2 reps []) in *.
  assert (Hr1 : length rep1 = n /\ (forall v, In v rep1 -> v < n)) by (apply Hreps, nth_In; auto).
  assert (Hr2 : length rep2 = n /\ (forall v, In v rep2 -> v < n)) by (apply Hreps, nth_In; auto).
  assert (Row : forall w j, w < W -> j < n -> NatSort.sort (nth w reps []) = seq 0 n -> rowval s w j = j).
  { intros w j Hw Hj Hs. rewrite goal_row by auto. rewrite Hs, seq_nth by auto. reflexivity. }
  assert (F : forall v, v < n -> findpos v rep1 = findpos v rep2).
  { intros v Hv. specialize (K v ltac:(lia)). rewrite !Row in K by auto.
    unfold idx in K. destruct (Nat.eqb_spec v n); [lia|]. exact K. }
  apply nth_ext with (d := 0) (d' := 0); [lia|].
  intros i Hi. set (v := nth i rep1 0).
  assert (Hv : v < n) by (apply Hr1, nth_In; auto).
  assert (P1 : findpos v rep1 = i) by (apply findpos_nodup; auto).
  rewrite F in P1 by auto.
  destruct (findpos_cases v rep2) as [[_ [_ B]]|[_ A]]; [|lia].
  rewrite P1 in B. auto.
Qed.

Fixpoint all_bools (c : nat) : list (list bool) :=
  match c with 0 => [[]] | S c' => map (cons true) (all_bools c') ++ map (cons false) (all_bools c') end.

Lemma all_bools_len c : length (all_bools c) = 2 ^ c.
Proof. induction c; simpl; auto. rewrite length_app, !length_map. lia. Qed.

Lemma all_bools_in l : In l (all_bools (length l)).
Proof.
  induction l; simpl; auto. apply in_or_app. destruct a; [left|right]; apply in_map; auto.
Qed.

Lemma NoDup_map_inj {A B} (f : A -> B) l : NoDup l ->
  (forall x y, In x l -> In y l -> f x = f y -> x = y) -> NoDup (map f l).
Proof.
  induction l as [|a l IH]; simpl; intros ND H; constructor.
  - inversion ND; subst. intros Hin. apply in_map_iff in Hin as [x [E Hx]].
    assert (x = a) by (apply H; auto). subst. auto.
  - inversion ND; subst. apply IH; auto.
Qed.

Lemma class_bound s p G : vwf R W s -> (forall i, In i p -> instr_wf R i) ->
  NoDup G -> incl G strict -> (forall w1 w2, In w1 G -> In w2 G -> ksim s w1 w2) ->
  vgoal n reps (vrun p s) -> length G <= 2 ^ ncmp p.
Proof.
  intros Hs Hp ND Hinc K Hg.
  rewrite <- all_bools_len, <- (length_map (fun w => bits p s w) G).
  apply NoDup_incl_length.
  - apply NoDup_map_inj; auto. intros x y Hx Hy E.
    apply (ksim_goal (vrun p s)); auto.
    apply ksim_run; auto; apply Hstrict; auto.
  - intros l Hl. apply in_map_iff in Hl as [w [<- _]].
    rewrite <- (bits_len p s w). apply all_bools_in.
Qed.

Definition cnt (s : vst) (w : nat) : nat :=
  length (filter (fun w' => col_eqb (key s w') (key s w)) strict).

Definition hcb (s : vst) (b : nat) : bool :=
  existsb (fun w => Nat.ltb (2 ^ (b - hw s)) (cnt s w)) strict.

Definition prune (s : vst) (b : nat) : bool := deadb s || Nat.ltb b (hw s) || hcb s b.

Theorem prune_sound s b : vwf R W s -> prune s b = true -> ~ vgood n R reps s b.
Proof.
  intros Hs Hpr Hgd. unfold prune in Hpr.
  apply orb_true_iff in Hpr as [Hpr|Hpr]; [apply orb_true_iff in Hpr as [Hpr|Hpr]|].
  - eapply deadb_sound; eauto.
  - destruct Hgd as [p [Hl [Hok Hg]]].
    pose proof (hw_run p s Hs (fun i H => proj1 (Hok i H)) Hg). pose proof (ncmp_nnon p).
    apply Nat.ltb_lt in Hpr. lia.
  - destruct Hgd as [p [Hl [Hok Hg]]].
    assert (Hp : forall i, In i p -> instr_wf R i) by (intros; apply Hok; auto).
    pose proof (hw_run p s Hs Hp Hg). pose proof (ncmp_nnon p).
    apply existsb_exists in Hpr as [w [Hw Hlt]]. apply Nat.ltb_lt in Hlt.
    set (G := filter (fun w' => col_eqb (key s w') (key s w)) strict).
    assert (HG : length G <= 2 ^ ncmp p).
    { apply (class_bound s p G Hs Hp).
      - apply NoDup_filter; auto.
      - intros x Hx. apply filter_In in Hx. tauto.
      - intros w1 w2 H1 H2. apply filter_In in H1 as [_ H1]. apply filter_In in H2 as [_ H2].
        apply col_eqb_spec in H1, H2. apply key_ksim. congruence.
      - auto. }
    assert (2 ^ ncmp p <= 2 ^ (b - hw s)) by (apply Nat.pow_le_mono_r; lia).
    unfold cnt in Hlt. fold G in Hlt. lia.
Qed.

End Prune.
