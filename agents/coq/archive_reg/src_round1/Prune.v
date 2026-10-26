(* Prune.v -- soundness of the prune rules in M_out (same ideas as agents/enum PRUNING.md D, H1, H2):
   dead : on some input w, the value tgt_j(w) of an undone output j is in no register -> never done;
   hw   : number of undone outputs; each needs its own non-cmp instruction (targets are distinct columns);
   hc   : a class of G strict inputs with equal (flag, held input index per register, input index of each
          done output) needs >= log2 |G| more cmp instructions.
   Theorem prune_sound: marked s -> prune s b = true -> ~ vgood s b. *)
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

Lemma filter_part {A} (f : A -> bool) l : length (filter f l) + length (filter (fun x => negb (f x)) l) = length l.
Proof. induction l; simpl; auto. destruct (f a); simpl; lia. Qed.

Lemma len_le_one {A} (l : list A) : NoDup l -> (forall x y, In x l -> In y l -> x = y) -> length l <= 1.
Proof.
  intros ND H. destruct l as [|a [|b l]]; simpl; auto.
  inversion ND; subst. exfalso. apply H2. rewrite (H a b); simpl; auto.
Qed.

Section Prune.
Variables (n R : nat) (reps : list (list nat)) (iset : cond -> bool).
Let W := length reps.
Hypothesis Hreps : reps_ok n reps.
Hypothesis Htd : forall j1 j2, j1 < n -> j2 < n -> tgt reps j1 = tgt reps j2 -> j1 = j2.
Variable tg : list col.
Hypothesis Htg : forall j, j < n -> nth j tg [] = tgt reps j.

Local Notation has := (has R reps).
Local Notation achieved := (achieved R reps).
Local Notation vgood := (vgood n R reps iset).

Definition rowval (s : vst) (w r : nat) : nat := nth w (getc s r) 0.

Lemma rowval_mov s d src w r : vwf R W s -> d < R -> src < R ->
  rowval (vstep s (Mov d src)) w r = if Nat.eqb r d then rowval s w src else rowval s w r.
Proof.
  intros [L _] Hd Hs. unfold rowval. destruct s as [cs fs ds]; simpl in *.
  rewrite getc_setn by lia. destruct (Nat.eqb r d); auto.
Qed.

Lemma rowval_cmov s c d src w r : vwf R W s -> d < R -> src < R -> w < W ->
  rowval (vstep s (Cmov c d src)) w r =
  if Nat.eqb r d then (if cond_eval c (nth w (flags s) Eq) then rowval s w src else rowval s w d)
  else rowval s w r.
Proof.
  intros Hw Hd Hs Hww. pose proof Hw as [L [_ L3]].
  assert (Lc : forall r, r < R -> length (getc s r) = W) by (intros; eapply getc_len; eauto).
  unfold rowval. destruct s as [cs fs ds]; simpl in *.
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

Lemma tgt_row w j : w < W -> j < n -> nth w (tgt reps j) 0 = nth j (NatSort.sort (nth w reps [])) 0.
Proof. intros Hw Hj. unfold tgt. rewrite (nth_map_lt _ _ _ _ []) by auto. reflexivity. Qed.

Lemma has_row s j w : has s j -> w < W -> exists r, r < R /\ rowval s w r = nth w (tgt reps j) 0.
Proof. intros [r [Hr E]] Hw. exists r. split; auto. unfold rowval. now rewrite E. Qed.

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

Definition deadb (s : vst) : bool :=
  existsb (fun w => existsb (fun j => negb (nth j (dn s) false) &&
             forallb (fun c => negb (Nat.eqb (nth w c 0) (nth w (nth j tg []) 0))) (cols s))
           (seq 0 n))
          (seq 0 W).

Lemma deadb_sound s b : vwf R W s -> deadb s = true -> ~ vgood s b.
Proof.
  intros Hs Hd [p [_ [Hok Hg]]]. unfold deadb in Hd.
  apply existsb_exists in Hd as [w [Hw Hd]]. apply in_seq in Hw.
  apply existsb_exists in Hd as [j [Hj Hd]]. apply in_seq in Hj.
  apply andb_true_iff in Hd as [Hnd Hd]. apply negb_true_iff in Hnd. rewrite Htg in Hd by lia.
  assert (Ha : absent s w (nth w (tgt reps j) 0)).
  { intros r Hr E. rewrite forallb_forall in Hd. pose proof Hs as [L _].
    specialize (Hd (getc s r) ltac:(unfold getc; apply nth_In; lia)).
    apply negb_true_iff, Nat.eqb_neq in Hd. apply Hd, E. }
  destruct (Hg j ltac:(lia)) as [D|[t [Ht Hh]]]; [unfold isdone in D; congruence|].
  assert (Hp : forall i, In i (firstn t p) -> instr_wf R i) by (apply firstn_wf; intros; apply Hok; auto).
  pose proof (absent_run (firstn t p) s w _ Hs Hp ltac:(lia) Ha) as Ha'.
  destruct (has_row _ j w Hh ltac:(lia)) as [r [Hr E]]. apply (Ha' r Hr E).
Qed.

(* ---------- hw ---------- *)
Definition hw (s : vst) : nat := length (filter (fun j => negb (nth j (dn s) false)) (seq 0 n)).

Lemma has_cmp s a b j : has (vstep s (Cmp a b)) j <-> has s j.
Proof. unfold has, getc. simpl. tauto. Qed.

Lemma has_new s s' d j : d < R -> (forall r, r < R -> r <> d -> getc s' r = getc s r) ->
  has s' j -> ~ has s j -> getc s' d = tgt reps j.
Proof.
  intros Hd Ho [r [Hr E]] Hn.
  destruct (Nat.eq_dec r d) as [->|Hrd]; auto. exfalso. apply Hn. exists r. split; auto.
  rewrite <- Ho; auto.
Qed.

Lemma other_mov s d src r : length (cols s) = R -> d < R -> r <> d -> getc (vstep s (Mov d src)) r = getc s r.
Proof.
  intros L Hd Hr. destruct s as [cs fs ds]. simpl in *. rewrite getc_setn by lia.
  apply Nat.eqb_neq in Hr. now rewrite Hr.
Qed.

Lemma other_cmov s c d src r : length (cols s) = R -> d < R -> r <> d -> getc (vstep s (Cmov c d src)) r = getc s r.
Proof.
  intros L Hd Hr. destruct s as [cs fs ds]. simpl in *. rewrite getc_setn by lia.
  apply Nat.eqb_neq in Hr. now rewrite Hr.
Qed.

Lemma has_dec s j : {has s j} + {~ has s j}.
Proof.
  destruct (existsb (fun r => if list_eq_dec Nat.eq_dec (getc s r) (tgt reps j) then true else false)
              (seq 0 R)) eqn:E.
  - left. apply existsb_exists in E as [r [Hr E]]. apply in_seq in Hr.
    exists r. split; [lia|]. destruct (list_eq_dec _ _ _); [auto|discriminate].
  - right. intros [r [Hr H]].
    assert (existsb (fun r => if list_eq_dec Nat.eq_dec (getc s r) (tgt reps j) then true else false)
              (seq 0 R) = true).
    { apply existsb_exists. exists r. split; [apply in_seq; lia|]. destruct (list_eq_dec _ _ _); auto. }
    congruence.
Qed.

Definition hasb s j : bool := if has_dec s j then true else false.

Lemma ach_count p s J : vwf R W s -> (forall i, In i p -> instr_wf R i) -> NoDup J ->
  (forall j, In j J -> j < n /\ ~ has s j /\ achieved p s j) -> length J <= nnon p.
Proof.
  revert s J; induction p as [|i p IH]; intros s J Hs Hp ND HJ.
  - destruct J as [|j J]; simpl; [lia|]. exfalso.
    destruct (HJ j (or_introl eq_refl)) as [_ [Hn [t [Ht Hh]]]]. simpl in Ht.
    assert (t = 0) by lia. subst. apply Hn, Hh.
  - set (s1 := vstep s i).
    assert (Hi : instr_wf R i) by (apply Hp; now left).
    assert (Hs1 : vwf R W s1) by (apply vwf_step; auto).
    rewrite <- (filter_part (fun j => hasb s1 j) J).
    assert (H2 : length (filter (fun j => negb (hasb s1 j)) J) <= nnon p).
    { apply (IH s1); auto.
      - intros; apply Hp; now right.
      - apply NoDup_filter; auto.
      - intros j Hj. apply filter_In in Hj as [Hj Hb]. destruct (HJ j Hj) as [Hjn [Hn [t [Ht Hh]]]].
        unfold hasb in Hb. destruct (has_dec s1 j) as [|Hn1]; [discriminate|].
        split; auto. split; auto. destruct t as [|t]; [contradiction|].
        exists t. simpl in Ht. split; [lia|]. exact Hh. }
    assert (H1 : length (filter (fun j => hasb s1 j) J) <= if isCmp i then 0 else 1).
    { destruct i as [d r|a b|c d r] eqn:Ei; simpl.
      - apply len_le_one; [apply NoDup_filter; auto|]. intros x y Hx Hy.
        apply filter_In in Hx as [Hx Hbx]. apply filter_In in Hy as [Hy Hby].
        unfold hasb in Hbx, Hby. destruct (has_dec s1 x) as [Hx1|]; [|discriminate].
        destruct (has_dec s1 y) as [Hy1|]; [|discriminate].
        destruct (HJ x Hx) as [Hxn [Hxs _]]. destruct (HJ y Hy) as [Hyn [Hys _]].
        assert (Hd : d < R) by (apply Hi; simpl; auto).
        assert (Ho : forall r', r' < R -> r' <> d -> getc s1 r' = getc s r')
          by (intros; apply other_mov; auto; apply Hs).
        apply Htd; auto.
        rewrite <- (has_new s s1 d x Hd Ho Hx1 Hxs). rewrite <- (has_new s s1 d y Hd Ho Hy1 Hys). reflexivity.
      - rewrite (filter_ext_in _ (fun _ => false)).
        + replace (filter (fun _ : nat => false) J) with (@nil nat) by (clear; induction J; simpl; auto).
          simpl; lia.
        + intros x Hx. unfold hasb. destruct (has_dec s1 x) as [H|]; auto. exfalso.
          destruct (HJ x Hx) as [_ [Hn _]]. apply Hn, (proj1 (has_cmp s a b x)), H.
      - apply len_le_one; [apply NoDup_filter; auto|]. intros x y Hx Hy.
        apply filter_In in Hx as [Hx Hbx]. apply filter_In in Hy as [Hy Hby].
        unfold hasb in Hbx, Hby. destruct (has_dec s1 x) as [Hx1|]; [|discriminate].
        destruct (has_dec s1 y) as [Hy1|]; [|discriminate].
        destruct (HJ x Hx) as [Hxn [Hxs _]]. destruct (HJ y Hy) as [Hyn [Hys _]].
        assert (Hd : d < R) by (apply Hi; simpl; auto).
        assert (Ho : forall r', r' < R -> r' <> d -> getc s1 r' = getc s r')
          by (intros; apply other_cmov; auto; apply Hs).
        apply Htd; auto.
        rewrite <- (has_new s s1 d x Hd Ho Hx1 Hxs). rewrite <- (has_new s s1 d y Hd Ho Hy1 Hys). reflexivity. }
    unfold nnon in *. simpl. destruct (isCmp i); simpl in *; lia.
Qed.

Lemma hw_sound s p : vwf R W s -> marked n R reps s -> (forall i, In i p -> instr_wf R i) ->
  (forall j, j < n -> isdone s j \/ achieved p s j) -> hw s <= nnon p.
Proof.
  intros Hs Hm Hp Hg. unfold hw. apply ach_count with s; auto.
  - apply NoDup_filter, seq_NoDup.
  - intros j Hj. apply filter_In in Hj as [Hj Hnd]. apply in_seq in Hj. apply negb_true_iff in Hnd.
    split; [lia|]. split.
    + intros Hh. specialize (Hm j ltac:(lia) Hh). unfold isdone in Hm. congruence.
    + destruct (Hg j ltac:(lia)) as [D|A]; auto. unfold isdone in D. congruence.
Qed.

(* ---------- hc ---------- *)
Fixpoint findpos (v : nat) (l : list nat) : nat :=
  match l with [] => S (n + v) | h :: t => if Nat.eqb h v then 0 else S (findpos v t) end.

Definition idx (w v : nat) : nat := if Nat.eqb v n then n else findpos v (nth w reps []).

Definition fcode (f : comparison) : nat := match f with Lt => 0 | Eq => 1 | Gt => 2 end.

Definition key (s : vst) (w : nat) : list nat :=
  fcode (nth w (flags s) Eq) :: map (fun c => idx w (nth w c 0)) (cols s)
  ++ map (fun j => if nth j (dn s) false then findpos j (nth w reps []) else 0) (seq 0 n).

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
  (forall r, r < R -> idx w1 (rowval s w1 r) = idx w2 (rowval s w2 r)) /\
  (forall j, j < n -> isdone s j -> findpos j (nth w1 reps []) = findpos j (nth w2 reps [])).

Lemma fcode_inj f g : fcode f = fcode g -> f = g.
Proof. destruct f, g; simpl; congruence. Qed.

Lemma app_len_inj {A} (a b c d : list A) : a ++ b = c ++ d -> length a = length c -> a = c /\ b = d.
Proof.
  revert c; induction a as [|x a IH]; intros [|y c]; simpl; intros E L; try discriminate; auto.
  inversion E; subst. destruct (IH c H1) as [-> ->]; auto.
Qed.

Lemma key_ksim s w1 w2 : length (cols s) = R -> key s w1 = key s w2 -> ksim s w1 w2.
Proof.
  unfold key. intros L E. inversion E as [[E1 E2]].
  apply app_len_inj in E2 as [E2 E3]; [|now rewrite !length_map].
  split; [now apply fcode_inj|]. split.
  - intros r Hr.
    assert (A : forall w, nth r (map (fun c => idx w (nth w c 0)) (cols s)) 0 = idx w (rowval s w r)).
    { intros w. rewrite (nth_map_lt _ _ _ _ []); [reflexivity|]. unfold col in L. lia. }
    rewrite <- (A w1), <- (A w2). now rewrite E2.
  - intros j Hj D.
    assert (A : forall w, nth j (map (fun j => if nth j (dn s) false then findpos j (nth w reps []) else 0)
                                     (seq 0 n)) 0 = findpos j (nth w reps [])).
    { intros w. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto). rewrite seq_nth by auto.
      simpl. unfold isdone in D. now rewrite D. }
    rewrite <- (A w1), <- (A w2). now rewrite E3.
Qed.

Lemma dn_step s i : dn (vstep s i) = dn s.
Proof. destruct i; reflexivity. Qed.

Lemma ksim_step s i w1 w2 : vwf R W s -> instr_wf R i -> w1 < W -> w2 < W -> ksim s w1 w2 ->
  (isCmp i = true -> (match nth w1 (flags (vstep s i)) Eq with Lt => true | _ => false end) =
                     (match nth w2 (flags (vstep s i)) Eq with Lt => true | _ => false end)) ->
  ksim (vstep s i) w1 w2.
Proof.
  intros Hs Hi H1 H2 [Kf [Kr Kd]] Hb. unfold instr_wf in Hi.
  assert (Kd' : forall j, j < n -> isdone (vstep s i) j ->
                findpos j (nth w1 reps []) = findpos j (nth w2 reps []))
    by (intros j Hj D; unfold isdone in D; rewrite dn_step in D; auto).
  destruct i as [d src|a b|c d src]; simpl in Hi.
  - assert (d < R) by auto. assert (src < R) by auto.
    split; [exact Kf|]. split; auto. intros r Hr. rewrite !rowval_mov by auto.
    destruct (Nat.eqb r d); auto.
  - assert (a < R) by auto. assert (b < R) by auto.
    specialize (Hb eq_refl). rewrite !flags_cmp in Hb by auto.
    split; [|split; auto; intros r Hr; rewrite !rowval_cmp; auto].
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
    split; [exact Kf|]. split; auto. intros r Hr. rewrite !rowval_cmov by auto.
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

Lemma bits_app p q s w : bits (p ++ q) s w = bits p s w ++ bits q (vrun p s) w.
Proof.
  revert s; induction p as [|i p IH]; simpl; intros s; auto.
  destruct (isCmp i); simpl; rewrite IH; auto.
Qed.

Lemma bits_prefix p t s w1 w2 : bits p s w1 = bits p s w2 -> bits (firstn t p) s w1 = bits (firstn t p) s w2.
Proof.
  intros E. rewrite <- (firstn_skipn t p) in E. rewrite !bits_app in E.
  apply app_len_inj in E as [E _]; auto. now rewrite !bits_len.
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

Lemma ksim_goal s p w1 w2 : vwf R W s -> (forall i, In i p -> instr_wf R i) ->
  In w1 strict -> In w2 strict -> (forall j, j < n -> isdone s j \/ achieved p s j) ->
  ksim s w1 w2 -> bits p s w1 = bits p s w2 -> w1 = w2.
Proof.
  intros Hs Hp I1 I2 Hg K B.
  destruct (Hstrict w1 I1) as [W1 [N1 S1]]. destruct (Hstrict w2 I2) as [W2 [N2 S2]].
  apply Hsdist; auto.
  set (rep1 := nth w1 reps []) in *. set (rep2 := nth w2 reps []) in *.
  assert (Hr1 : length rep1 = n /\ (forall v, In v rep1 -> v < n)) by (apply Hreps, nth_In; auto).
  assert (Hr2 : length rep2 = n /\ (forall v, In v rep2 -> v < n)) by (apply Hreps, nth_In; auto).
  assert (F : forall v, v < n -> findpos v rep1 = findpos v rep2).
  { intros v Hv. destruct (Hg v Hv) as [D|[t [Ht Hh]]]; [apply K; auto|].
    set (st := vrun (firstn t p) s).
    assert (Hpt : forall i, In i (firstn t p) -> instr_wf R i) by (apply firstn_wf; auto).
    assert (Kt : ksim st w1 w2) by (apply ksim_run; auto; apply bits_prefix; auto).
    destruct Hh as [r [Hr E]].
    assert (Row : forall w, w < W -> NatSort.sort (nth w reps []) = seq 0 n -> rowval st w r = v).
    { intros w Hw Hsw. unfold rowval. fold st in E. rewrite E, tgt_row, Hsw, seq_nth by auto. reflexivity. }
    destruct Kt as [_ [Kr _]]. specialize (Kr r Hr). rewrite !Row in Kr by auto.
    unfold idx in Kr. destruct (Nat.eqb_spec v n); [lia|]. exact Kr. }
  apply nth_ext with (d := 0) (d' := 0); [lia|].
  intros i Hi. set (v := nth i rep1 0).
  assert (Hv : v < n) by (apply Hr1, nth_In; auto).
  assert (P1 : findpos v rep1 = i) by (apply findpos_nodup; auto).
  rewrite F in P1 by auto.
  destruct (findpos_cases v rep2) as [[_ [_ Bq]]|[_ A]]; [|lia].
  rewrite P1 in Bq. auto.
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
  (forall j, j < n -> isdone s j \/ achieved p s j) -> length G <= 2 ^ ncmp p.
Proof.
  intros Hs Hp ND Hinc K Hg.
  rewrite <- all_bools_len, <- (length_map (fun w => bits p s w) G).
  apply NoDup_incl_length.
  - apply NoDup_map_inj; auto. intros x y Hx Hy E.
    apply (ksim_goal s p); auto.
  - intros l Hl. apply in_map_iff in Hl as [w [<- _]].
    rewrite <- (bits_len p s w). apply all_bools_in.
Qed.

Definition hcb (s : vst) (b : nat) : bool :=
  let lim := 2 ^ (b - hw s) in
  Nat.ltb lim (length strict) &&
  (let ks := map (key s) strict in existsb (fun k => Nat.ltb lim (length (filter (col_eqb k) ks))) ks).

Definition prune (s : vst) (b : nat) : bool := Nat.ltb b (hw s) || deadb s || hcb s b.

Lemma filter_map_len {A B} (f : B -> bool) (g : A -> B) l :
  length (filter f (map g l)) = length (filter (fun x => f (g x)) l).
Proof. induction l; simpl; auto. destruct (f (g a)); simpl; auto. Qed.

Theorem prune_sound s b : vwf R W s -> marked n R reps s -> prune s b = true -> ~ vgood s b.
Proof.
  intros Hs Hm Hpr Hgd. unfold prune in Hpr.
  apply orb_true_iff in Hpr as [Hpr|Hpr]; [apply orb_true_iff in Hpr as [Hpr|Hpr]|].
  - destruct Hgd as [p [Hl [Hok Hg]]].
    assert (Hp : forall i, In i p -> instr_wf R i) by (intros; apply Hok; auto).
    pose proof (hw_sound s p Hs Hm Hp Hg). pose proof (ncmp_nnon p).
    apply Nat.ltb_lt in Hpr. lia.
  - eapply deadb_sound; eauto.
  - destruct Hgd as [p [Hl [Hok Hg]]].
    assert (Hp : forall i, In i p -> instr_wf R i) by (intros; apply Hok; auto).
    pose proof (hw_sound s p Hs Hm Hp Hg). pose proof (ncmp_nnon p).
    unfold hcb in Hpr. apply andb_true_iff in Hpr as [_ Hpr].
    apply existsb_exists in Hpr as [k [Hk Hlt]]. apply Nat.ltb_lt in Hlt.
    apply in_map_iff in Hk as [w [<- Hw]].
    rewrite filter_map_len in Hlt.
    set (G := filter (fun w' => col_eqb (key s w) (key s w')) strict) in Hlt.
    assert (HG : length G <= 2 ^ ncmp p).
    { apply (class_bound s p G Hs Hp).
      - apply NoDup_filter; auto.
      - intros x Hx. apply filter_In in Hx. tauto.
      - intros w1 w2 H1 H2. apply filter_In in H1 as [_ H1]. apply filter_In in H2 as [_ H2].
        apply col_eqb_spec in H1, H2. apply key_ksim; [apply Hs|]. congruence.
      - auto. }
    assert (2 ^ ncmp p <= 2 ^ (b - hw s)) by (apply Nat.pow_le_mono_r; lia).
    lia.
Qed.

End Prune.
