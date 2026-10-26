(* SetModel.v -- enum's set model (PRUNING.md Lemma S) over an abstract column type C.
   A set state = (A = set of non-T columns, flag vector, done mask).  Set operations: cmp a b (cost 1),
   cmov in place (cost 1; on T it adds the result), cmov into a copy (cost 2).  T columns are never stored.
   Theorem lemma_S: a register program of length L from a register state s, with A covering the non-T columns
   of s, gives a set program of cost <= L + Phi s, Phi s = #non-T registers - #distinct non-T columns.
   C is abstract (with a list view dec) so that a packed implementation can be plugged in. *)
From Stdlib Require Import List Bool Lia Arith Permutation ListDec Mergesort PArith FMapPositive.
From CmovSort Require Import Machine Vec Good Prune.
Import ListNotations.

Section SetModel.
Variables (n R : nat) (reps : list (list nat)) (iset : cond -> bool).
Let W := length reps.
Hypothesis HW : 0 < W.
Hypothesis Hreps : reps_ok n reps.

Variables (C F : Type) (dec : C -> col) (decf : F -> list comparison).
Hypothesis dec_inj : forall a b, dec a = dec b -> a = b.
Hypothesis dec_len : forall a, length (dec a) = W.
Hypothesis decf_len : forall f, length (decf f) = W.
Variable ceqb : C -> C -> bool.
Hypothesis ceqb_spec : forall a b, ceqb a b = true <-> a = b.
Variable blendp : cond -> F -> C -> C -> C.
Hypothesis blendp_spec : forall c f a b, dec (blendp c f a b) = blend c (decf f) (dec a) (dec b).
Variable cmpp : C -> C -> F.
Hypothesis cmpp_spec : forall a b, decf (cmpp a b) = cmpcol (dec a) (dec b).
Variable Tp : C.
Hypothesis Tp_spec : dec Tp = repeat n W.
Variable tgp : list C.
Hypothesis tgp_spec : forall j, j < n -> dec (nth j tgp Tp) = tgt reps j.

Definition Tl : col := repeat n W.
Definition nonT (x : col) : bool := negb (col_eqb x Tl).

(* ---------- set states and operations ---------- *)
Record sst := SS { sA : list C; sf : F; sdn : list bool }.

Inductive sop := SCmp (a b : C) | SIn (c : cond) (d s : C) | SCopy (c : cond) (d s : C).

Definition memb (x : C) (l : list C) : bool := existsb (ceqb x) l.
Definition addc (x : C) (l : list C) : list C := if ceqb x Tp then l else if memb x l then l else x :: l.
Definition remc (x : C) (l : list C) : list C := filter (fun y => negb (ceqb x y)) l.

Definition smark (s : sst) : sst :=
  SS (sA s) (sf s) (map (fun j => if nth j (sdn s) false then true else memb (nth j tgp Tp) (sA s)) (seq 0 n)).

Definition sstep (s : sst) (o : sop) : sst :=
  smark (match o with
         | SCmp a b => SS (sA s) (cmpp a b) (sdn s)
         | SIn c d x => SS (addc (blendp c (sf s) d x) (remc d (sA s))) (sf s) (sdn s)
         | SCopy c d x => SS (addc (blendp c (sf s) d x) (sA s)) (sf s) (sdn s)
         end).

Definition cost (o : sop) : nat := match o with SCopy _ _ _ => 2 | _ => 1 end.

Definition opnd (s : sst) (x : C) : Prop := x = Tp \/ In x (sA s).

Definition valid (s : sst) (o : sop) : Prop :=
  match o with
  | SCmp a b => opnd s a /\ opnd s b
  | SIn c d x | SCopy c d x => iset c = true /\ opnd s d /\ opnd s x
  end.

Definition sdone (s : sst) : Prop := forall j, j < n -> nth j (sdn s) false = true.

Inductive sgood : sst -> nat -> Prop :=
| sg_done s b : sdone s -> sgood s b
| sg_step s b o : valid s o -> sgood (sstep s o) b -> sgood s (cost o + b).

Lemma sgood_mono s b b' : sgood s b -> b <= b' -> sgood s b'.
Proof.
  intros H. revert b'. induction H; intros b' Hb.
  - now apply sg_done.
  - replace b' with (cost o + (b' - cost o)) by lia. apply sg_step; auto. apply IHsgood. lia.
Qed.

Lemma memb_spec x l : memb x l = true <-> In x l.
Proof.
  unfold memb. rewrite existsb_exists. split.
  - intros [y [Hy E]]. apply ceqb_spec in E. now subst.
  - intros H. exists x. split; auto. now apply ceqb_spec.
Qed.

Lemma ceqb_refl x : ceqb x x = true.
Proof. now apply ceqb_spec. Qed.

Lemma in_addc x y l : In y (addc x l) -> In y l \/ y = x.
Proof. unfold addc. destruct (ceqb x Tp), (memb x l); simpl; intuition. Qed.

Lemma addc_in x l : x <> Tp -> In x (addc x l).
Proof.
  intros H. unfold addc. destruct (ceqb x Tp) eqn:E; [apply ceqb_spec in E; contradiction|].
  destruct (memb x l) eqn:M; [apply memb_spec; auto|now left].
Qed.

Lemma addc_sub x y l : In y l -> In y (addc x l).
Proof. unfold addc. destruct (ceqb x Tp), (memb x l); simpl; auto. Qed.

Lemma in_remc x y l : In y (remc x l) <-> In y l /\ y <> x.
Proof.
  unfold remc. rewrite filter_In. split; intros [H1 H2]; split; auto.
  - intros ->. rewrite ceqb_refl in H2. discriminate.
  - destruct (ceqb x y) eqn:E; auto. apply ceqb_spec in E. congruence.
Qed.

Lemma smark_marked s : forall j, j < n -> memb (nth j tgp Tp) (sA (smark s)) = true -> nth j (sdn (smark s)) false = true.
Proof.
  intros j Hj H. unfold smark in *; simpl in *. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
  rewrite seq_nth by auto. simpl. rewrite H. destruct (nth j (sdn s) false); auto.
Qed.

Lemma smark_mono s j : j < n -> nth j (sdn s) false = true -> nth j (sdn (smark s)) false = true.
Proof.
  intros Hj H. unfold smark; simpl. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
  rewrite seq_nth by auto. simpl. now rewrite H.
Qed.

Lemma sstep_mono s o j : j < n -> nth j (sdn s) false = true -> nth j (sdn (sstep s o)) false = true.
Proof. intros Hj H. unfold sstep. apply smark_mono; auto. destruct o; exact H. Qed.

(* ---------- potential ---------- *)
Definition cdec : forall x y : col, {x = y} + {x <> y} := list_eq_dec Nat.eq_dec.
Definition ndl (l : list col) : nat := length (nodup cdec l).

Lemma ndl_cons x l : ndl (x :: l) = if in_dec cdec x l then ndl l else S (ndl l).
Proof. unfold ndl. simpl. destruct (in_dec cdec x l); reflexivity. Qed.

Lemma ndl_le l : ndl l <= length l.
Proof. induction l as [|x l IH]; [unfold ndl; simpl; lia|]. rewrite ndl_cons. destruct (in_dec cdec x l); cbn [length]; lia. Qed.

Lemma ndl_perm l l' : Permutation l l' -> ndl l = ndl l'.
Proof.
  intros P. unfold ndl. apply Nat.le_antisymm; apply NoDup_incl_length; try apply NoDup_nodup;
  intros x Hx; apply nodup_In; apply nodup_In in Hx; [eapply Permutation_in; eauto|].
  eapply Permutation_in; [apply Permutation_sym|]; eauto.
Qed.

Definition Lreg (s : vst) : list col := filter nonT (map (getc s) (seq 0 R)).
Definition Phi (s : vst) : nat := length (Lreg s) - ndl (Lreg s).

Definition rest (s : vst) (d : nat) : list col :=
  filter nonT (map (getc s) (seq 0 d ++ seq (S d) (R - S d))).

Lemma seq_split d : d < R -> seq 0 R = seq 0 d ++ d :: seq (S d) (R - S d).
Proof.
  intros H. replace R with (d + S (R - S d)) at 1 by lia. rewrite seq_app. reflexivity.
Qed.

Lemma Lreg_split s d : d < R ->
  Permutation (Lreg s) ((if nonT (getc s d) then [getc s d] else []) ++ rest s d).
Proof.
  intros H. unfold Lreg, rest. rewrite (seq_split d H), !map_app, !filter_app. simpl.
  destruct (nonT (getc s d)); simpl; [|reflexivity].
  apply Permutation_sym, Permutation_middle.
Qed.

Lemma Phi_split s d : d < R ->
  Phi s = (if nonT (getc s d) then S (length (rest s d)) - (if in_dec cdec (getc s d) (rest s d)
                                                              then ndl (rest s d) else S (ndl (rest s d)))
           else length (rest s d) - ndl (rest s d)).
Proof.
  intros H. unfold Phi. pose proof (Lreg_split s d H) as P.
  rewrite (Permutation_length P), (ndl_perm _ _ P).
  destruct (nonT (getc s d)); simpl; [rewrite ndl_cons|]; reflexivity.
Qed.

Lemma rest_upd s s' d : d < R -> (forall r, r < R -> r <> d -> getc s' r = getc s r) -> rest s' d = rest s d.
Proof.
  intros H E. unfold rest. f_equal. apply map_ext_in. intros r Hr. apply E.
  - apply in_app_iff in Hr as [Hr|Hr]; apply in_seq in Hr; lia.
  - apply in_app_iff in Hr as [Hr|Hr]; apply in_seq in Hr; lia.
Qed.

Lemma in_rest s d r : d < R -> r < R -> r <> d -> nonT (getc s r) = true -> In (getc s r) (rest s d).
Proof.
  intros Hd Hr Hrd Hn. unfold rest. apply filter_In. split; auto. apply in_map. apply in_app_iff.
  destruct (Nat.lt_ge_cases r d); [left; apply in_seq; lia|right; apply in_seq; lia].
Qed.

Lemma rest_in s d x : d < R -> In x (rest s d) -> nonT x = true /\ exists r, r < R /\ r <> d /\ getc s r = x.
Proof.
  unfold rest. intros Hd H. apply filter_In in H as [H Hn]. split; auto.
  apply in_map_iff in H as [r [<- Hr]]. exists r. apply in_app_iff in Hr as [Hr|Hr]; apply in_seq in Hr;
  (split; [lia|split; [lia|auto]]).
Qed.

Lemma ndl_rest_le s d : ndl (rest s d) <= length (rest s d).
Proof. apply ndl_le. Qed.

(* ---------- Lemma S ---------- *)
Definition smarked (t : sst) : Prop :=
  forall j, j < n -> memb (nth j tgp Tp) (sA t) = true -> nth j (sdn t) false = true.

Definition Inv (s : vst) (t : sst) : Prop :=
  (forall r, r < R -> nonT (getc s r) = true -> exists a, In a (sA t) /\ dec a = getc s r) /\
  decf (sf t) = flags s /\ (forall a, In a (sA t) -> a <> Tp) /\ smarked t.

Lemma sstep_marked t o : smarked (sstep t o).
Proof. intros j Hj H. unfold sstep in *. apply smark_marked; auto. Qed.

Lemma nonT_false x : nonT x = false -> x = Tl.
Proof. unfold nonT. intros H. apply negb_false_iff, col_eqb_spec in H. exact H. Qed.

Lemma tgt_nonT j : j < n -> nonT (tgt reps j) = true.
Proof.
  intros Hj. unfold nonT. apply negb_true_iff. destruct (col_eqb _ _) eqn:E; auto. exfalso.
  apply col_eqb_spec in E. set (rep := nth 0 reps []).
  assert (Hr : length rep = n /\ (forall v, In v rep -> v < n)) by (apply Hreps, nth_In; lia).
  assert (E0 : nth 0 (tgt reps j) 0 = nth 0 Tl 0) by now rewrite E.
  unfold tgt, Tl in E0. rewrite (nth_map_lt _ _ _ _ []) in E0 by lia. fold rep in E0.
  rewrite nth_repeat_lt in E0 by (unfold W in HW; lia).
  assert (In (nth j (NatSort.sort rep) 0) rep).
  { eapply Permutation_in; [apply Permutation_sym, NatSort.Permuted_sort|]. apply nth_In.
    rewrite <- (Permutation_length (NatSort.Permuted_sort rep)). lia. }
  apply Hr in H. lia.
Qed.

Lemma represent s t r : vwf R W s -> r < R -> Inv s t -> exists a, opnd t a /\ dec a = getc s r.
Proof.
  intros Hs Hr [I1 _]. destruct (nonT (getc s r)) eqn:E.
  - destruct (I1 r Hr E) as [a [Ha Ea]]. exists a. split; [right; auto|auto].
  - exists Tp. split; [left; auto|]. rewrite Tp_spec. symmetry. apply nonT_false, E.
Qed.

Lemma has_done s t j : Inv s t -> j < n -> has R reps s j -> nth j (sdn t) false = true.
Proof.
  intros [I1 [_ [_ Im]]] Hj [r [Hr E]]. apply Im; auto.
  assert (Hn : nonT (getc s r) = true) by (rewrite E; apply tgt_nonT; auto).
  destruct (I1 r Hr Hn) as [a [Ha Ea]]. apply memb_spec.
  replace (nth j tgp Tp) with a; auto. apply dec_inj. rewrite Ea, E, tgp_spec; auto.
Qed.

Definition upd_col (s : vst) (d : nat) (M : col) : vst := VS (setn (cols s) d M) (flags s) (dn s).

Lemma getc_upd s d M r : length (cols s) = R -> d < R -> getc (upd_col s d M) r = if Nat.eqb r d then M else getc s r.
Proof. intros L Hd. unfold upd_col. rewrite getc_setn by lia. destruct s; reflexivity. Qed.

Lemma Phi_upd_le s d M : length (cols s) = R -> d < R -> Phi (upd_col s d M) <= S (Phi s).
Proof.
  intros L Hd. rewrite (Phi_split s d Hd), (Phi_split (upd_col s d M) d Hd).
  rewrite (rest_upd s (upd_col s d M) d Hd) by (intros r Hr Hrd; rewrite getc_upd by auto;
    apply Nat.eqb_neq in Hrd; now rewrite Hrd).
  rewrite getc_upd by auto. rewrite Nat.eqb_refl. pose proof (ndl_le (rest s d)).
  destruct (nonT M), (nonT (getc s d)); repeat destruct (in_dec cdec _ _); lia.
Qed.

Lemma Inv_upd_old s t d M : vwf R W s -> d < R -> Inv s t ->
  (nonT M = false \/ exists a, In a (sA t) /\ dec a = M) -> Inv (upd_col s d M) t.
Proof.
  intros Hs Hd [I1 [I2 [I3 I4]]] HM. pose proof Hs as [L _]. split; [|split; auto].
  intros r Hr Hn. rewrite getc_upd in Hn |- * by auto. destruct (Nat.eqb_spec r d).
  - destruct HM as [HM|HM]; [congruence|auto].
  - apply I1; auto.
Qed.

Lemma notin_rest s t d M : vwf R W s -> d < R -> Inv s t -> ~ (exists a, In a (sA t) /\ dec a = M) ->
  ~ In M (rest s d).
Proof.
  intros Hs Hd [I1 _] HM Hin. apply rest_in in Hin as [Hn [r [Hr [Hrd E]]]]; auto. apply HM.
  subst M. apply I1; auto.
Qed.

Lemma prog_cons_ok i p : prog_ok iset R (i :: p) -> instr_wf R i /\ instr_in iset i = true /\ prog_ok iset R p.
Proof. intros H. split; [apply H; now left|]. split; [apply H; now left|]. intros x Hx. apply H. now right. Qed.

Lemma goal_step s t i p : Inv s t ->
  (forall j, j < n -> nth j (sdn t) false = true \/ achieved R reps (i :: p) s j) ->
  forall j, j < n -> nth j (sdn t) false = true \/ achieved R reps p (vstep s i) j.
Proof.
  intros HI H j Hj. destruct (H j Hj) as [D|[tm [Htm Hh]]]; [now left|].
  destruct tm as [|tm].
  - left. apply (has_done s t j HI Hj Hh).
  - right. exists tm. simpl in Htm. split; [lia|exact Hh].
Qed.

Lemma goal_mono t t' p s : (forall j, j < n -> nth j (sdn t) false = true -> nth j (sdn t') false = true) ->
  (forall j, j < n -> nth j (sdn t) false = true \/ achieved R reps p s j) ->
  forall j, j < n -> nth j (sdn t') false = true \/ achieved R reps p s j.
Proof. intros M H j Hj. destruct (H j Hj); auto. Qed.

Lemma Tp_notin s t : Inv s t -> remc Tp (sA t) = sA t.
Proof.
  intros [_ [_ [I3 _]]]. unfold remc. apply forallb_filter_id. apply forallb_forall.
  intros y Hy. destruct (ceqb Tp y) eqn:E; auto. apply ceqb_spec in E. rewrite <- E in Hy. exfalso. apply (I3 Tp Hy). auto.
Qed.

Theorem lemma_S p : forall s t, vwf R W s -> prog_ok iset R p -> Inv s t ->
  (forall j, j < n -> nth j (sdn t) false = true \/ achieved R reps p s j) ->
  sgood t (length p + Phi s).
Proof.
  induction p as [|i p IH]; intros s t Hs Hok HI Hg.
  - apply sg_done. intros j Hj. destruct (Hg j Hj) as [D|[tm [Htm Hh]]]; auto.
    simpl in Htm. assert (tm = 0) by lia. subst. apply (has_done s t j HI Hj Hh).
  - destruct (prog_cons_ok _ _ Hok) as [Hi [Hii Hp]].
    pose proof (goal_step s t i p HI Hg) as Hg1.
    pose proof Hs as [L [_ _]]. unfold instr_wf in Hi. simpl length.
    assert (Hs1 : vwf R W (vstep s i)) by (apply vwf_step; auto).
    destruct i as [d src|a b|c d src]; simpl in Hi.
    + (* mov: no set operation *)
      assert (Hd : d < R) by auto. assert (Hsr : src < R) by auto.
      assert (E : vstep s (Mov d src) = upd_col s d (getc s src)) by reflexivity.
      rewrite E in Hg1, Hs1.
      apply sgood_mono with (length p + Phi (upd_col s d (getc s src))).
      * apply IH; auto. apply Inv_upd_old; auto.
        destruct (nonT (getc s src)) eqn:N; [right; apply HI; auto|left; auto].
      * pose proof (Phi_upd_le s d (getc s src) L Hd). lia.
    + (* cmp *)
      assert (Ha : a < R) by auto. assert (Hb : b < R) by auto.
      destruct (represent s t a Hs Ha HI) as [ap [Oa Ea]]. destruct (represent s t b Hs Hb HI) as [bp [Ob Eb]].
      replace (S (length p) + Phi s) with (cost (SCmp ap bp) + (length p + Phi (vstep s (Cmp a b)))) by reflexivity.
      apply sg_step; [split; auto|]. apply IH; auto.
      * destruct HI as [I1 [I2 [I3 I4]]]. split; [|split; [|split]].
        -- intros r Hr Hn. apply I1; auto.
        -- simpl. rewrite cmpp_spec, Ea, Eb. reflexivity.
        -- simpl. exact I3.
        -- apply sstep_marked.
      * apply (goal_mono t); auto. intros j Hj D. apply sstep_mono; auto.
    + (* cmov *)
      assert (Hd : d < R) by auto. assert (Hsr : src < R) by auto.
      set (M := blend c (flags s) (getc s d) (getc s src)).
      assert (E : vstep s (Cmov c d src) = upd_col s d M) by reflexivity.
      rewrite E in Hg1, Hs1.
      destruct (nonT M) eqn:NM;
        [destruct (existsb (fun a => col_eqb (dec a) M) (sA t)) eqn:EM|].
      * (* M already in A: no set operation *)
        apply existsb_exists in EM as [a [Ha Ea]]. apply col_eqb_spec in Ea.
        apply sgood_mono with (length p + Phi (upd_col s d M)).
        -- apply IH; auto. apply Inv_upd_old; auto. right. exists a. auto.
        -- pose proof (Phi_upd_le s d M L Hd). lia.
      * (* M new *)
        assert (NA : ~ (exists a, In a (sA t) /\ dec a = M)).
        { intros [a [Ha Ea]]. assert (existsb (fun a => col_eqb (dec a) M) (sA t) = true).
          { apply existsb_exists. exists a. split; auto. apply col_eqb_spec; auto. } congruence. }
        pose proof (notin_rest s t d M Hs Hd HI NA) as NR.
        destruct (represent s t d Hs Hd HI) as [xp [Ox Ex]]. destruct (represent s t src Hs Hsr HI) as [sp [Os Es]].
        set (Mp := blendp c (sf t) xp sp).
        assert (EMp : dec Mp = M).
        { unfold Mp. rewrite blendp_spec, Ex, Es. destruct HI as [_ [I2 _]]. rewrite I2. reflexivity. }
        assert (MpT : Mp <> Tp).
        { intros H. rewrite H, Tp_spec in EMp. fold Tl in EMp. unfold nonT in NM. rewrite <- EMp in NM.
          assert (col_eqb Tl Tl = true) by (apply col_eqb_spec; auto). rewrite H0 in NM. discriminate. }
        assert (MpA : memb Mp (sA t) = false).
        { destruct (memb Mp (sA t)) eqn:Q; auto. apply memb_spec in Q. exfalso. apply NA. exists Mp. auto. }
        assert (Hrest : rest (upd_col s d M) d = rest s d)
          by (apply rest_upd; auto; intros r Hr Hrd; rewrite getc_upd by auto; apply Nat.eqb_neq in Hrd; now rewrite Hrd).
        assert (PhiN : Phi (upd_col s d M) = length (rest s d) - ndl (rest s d)).
        { rewrite (Phi_split _ d Hd), Hrest, getc_upd, Nat.eqb_refl, NM by auto.
          destruct (in_dec cdec M (rest s d)); [contradiction|]. pose proof (ndl_le (rest s d)). lia. }
        pose proof (ndl_le (rest s d)) as NL.
        destruct HI as [I1 [I2 [I3 I4]]].
        assert (Inv_new : forall A', (forall r, r < R -> r <> d -> nonT (getc s r) = true ->
                                        exists a, In a A' /\ dec a = getc s r) ->
                         In Mp A' -> (forall a, In a A' -> a <> Tp) ->
                         Inv (upd_col s d M) (smark (SS A' (sf t) (sdn t)))).
        { intros A' H1 H2 H3. split; [|split; [|split]].
          - intros r Hr Hn. rewrite getc_upd in Hn |- * by auto. destruct (Nat.eqb_spec r d).
            + exists Mp. auto.
            + apply H1; auto.
          - simpl. exact I2.
          - simpl. exact H3.
          - intros j Hj Q. apply smark_marked; auto. }
        destruct (nonT (getc s d)) eqn:NX; [destruct (in_dec cdec (getc s d) (rest s d)) as [XR|XR]|].
        -- (* X shared: copy, cost 2 *)
           assert (PhiO : Phi s = S (length (rest s d)) - ndl (rest s d)).
           { rewrite (Phi_split s d Hd), NX. destruct (in_dec cdec (getc s d) (rest s d)); [reflexivity|contradiction]. }
           replace (S (length p) + Phi s) with (cost (SCopy c xp sp) + (length p + Phi (upd_col s d M))) by (simpl; lia).
           apply sg_step; [split; auto|].
           replace (sstep t (SCopy c xp sp)) with (smark (SS (Mp :: sA t) (sf t) (sdn t)))
             by (unfold sstep, addc; simpl; fold Mp; destruct (ceqb Mp Tp) eqn:Q;
                 [apply ceqb_spec in Q; contradiction|rewrite MpA; reflexivity]).
           apply IH; auto.
           ++ apply Inv_new; [|now left|].
              ** intros r Hr Hrd Hn. destruct (I1 r Hr Hn) as [a [Ha Ea]]. exists a. split; [now right|auto].
              ** intros a [<-|Ha]; auto.
           ++ apply (goal_mono t); auto. intros j Hj D. apply smark_mono; auto.
        -- (* X unique: in place, cost 1 *)
           assert (PhiO : Phi s = length (rest s d) - ndl (rest s d)).
           { rewrite (Phi_split s d Hd), NX. destruct (in_dec cdec (getc s d) (rest s d)); [contradiction|lia]. }
           destruct Ox as [Ox|Ox].
           { exfalso. rewrite Ox, Tp_spec in Ex. fold Tl in Ex. unfold nonT in NX. rewrite <- Ex in NX.
             assert (col_eqb Tl Tl = true) by (apply col_eqb_spec; auto). rewrite H in NX. discriminate. }
           replace (S (length p) + Phi s) with (cost (SIn c xp sp) + (length p + Phi (upd_col s d M))) by (simpl; lia).
           apply sg_step; [split; auto; split; auto; right; auto|].
           assert (MpR : memb Mp (remc xp (sA t)) = false).
           { destruct (memb Mp (remc xp (sA t))) eqn:Q; auto. apply memb_spec, in_remc in Q as [Q _].
             apply memb_spec in Q. congruence. }
           replace (sstep t (SIn c xp sp)) with (smark (SS (Mp :: remc xp (sA t)) (sf t) (sdn t)))
             by (unfold sstep, addc; simpl; fold Mp; destruct (ceqb Mp Tp) eqn:Q;
                 [apply ceqb_spec in Q; contradiction|rewrite MpR; reflexivity]).
           apply IH; auto.
           ++ apply Inv_new; [|now left|].
              ** intros r Hr Hrd Hn. destruct (I1 r Hr Hn) as [a [Ha Ea]]. exists a. split; auto. right.
                 apply in_remc. split; auto. intros ->. apply XR. rewrite <- Ex, Ea. apply in_rest; auto.
              ** intros a [<-|Ha]; auto. apply in_remc in Ha as [Ha _]. auto.
           ++ apply (goal_mono t); auto. intros j Hj D. apply smark_mono; auto.
        -- (* X = T: cmov on T, cost 1 *)
           assert (PhiO : Phi s = length (rest s d) - ndl (rest s d)).
           { rewrite (Phi_split s d Hd), NX. reflexivity. }
           replace (S (length p) + Phi s) with (cost (SIn c xp sp) + (length p + Phi (upd_col s d M))) by (simpl; lia).
           apply sg_step; [split; auto|].
           assert (XT : xp = Tp).
           { apply dec_inj. rewrite Ex, Tp_spec. apply nonT_false, NX. }
           assert (RT : remc xp (sA t) = sA t) by (rewrite XT; apply (Tp_notin s); split; auto).
           replace (sstep t (SIn c xp sp)) with (smark (SS (Mp :: sA t) (sf t) (sdn t)))
             by (unfold sstep, addc; simpl; fold Mp; rewrite RT; destruct (ceqb Mp Tp) eqn:Q;
                 [apply ceqb_spec in Q; contradiction|rewrite MpA; reflexivity]).
           apply IH; auto.
           ++ apply Inv_new; [|now left|].
              ** intros r Hr Hrd Hn. destruct (I1 r Hr Hn) as [a [Ha Ea]]. exists a. split; [now right|auto].
              ** intros a [<-|Ha]; auto.
           ++ apply (goal_mono t); auto. intros j Hj D. apply smark_mono; auto.
      * (* M = T: no set operation *)
        apply sgood_mono with (length p + Phi (upd_col s d M)).
        -- apply IH; auto. apply Inv_upd_old; auto.
        -- pose proof (Phi_upd_le s d M L Hd). lia.
Qed.

(* ---------- more hypotheses for the rules ---------- *)
Hypothesis decf_inj : forall f g, decf f = decf g -> f = g.
Hypothesis Htd : forall j1 j2, j1 < n -> j2 < n -> tgt reps j1 = tgt reps j2 -> j1 = j2.
Hypothesis Hsym : forall c, iset (swapc c) = iset c.

(* ---------- op lists ---------- *)
Fixpoint srun (t : sst) (os : list sop) : sst := match os with [] => t | o :: os' => srun (sstep t o) os' end.
Fixpoint vseq (t : sst) (os : list sop) : Prop :=
  match os with [] => True | o :: os' => valid t o /\ vseq (sstep t o) os' end.
Definition costs (os : list sop) : nat := fold_right (fun o a => cost o + a) 0 os.

Lemma sgood_ops t b : sgood t b -> exists os, vseq t os /\ costs os <= b /\ sdone (srun t os).
Proof.
  induction 1 as [t b D|t b o V G [os [Vs [Cs Ds]]]].
  - exists []. simpl. split; auto. split; [lia|auto].
  - exists (o :: os). simpl. split; auto. split; [lia|auto].
Qed.

(* ---------- set equivalence: same members, same flags, same done mask ---------- *)
Definition SEq (t t' : sst) : Prop :=
  (forall x, In x (sA t) <-> In x (sA t')) /\ sf t' = sf t /\ sdn t' = sdn t.

Lemma memb_seq x l l' : (forall y, In y l <-> In y l') -> memb x l = memb x l'.
Proof.
  intros H. destruct (memb x l) eqn:E, (memb x l') eqn:E'; auto;
  apply memb_spec in E || apply memb_spec in E'.
  - apply H, memb_spec in E. congruence.
  - apply H, memb_spec in E'. congruence.
Qed.

Lemma addc_seq x l l' : (forall y, In y l <-> In y l') ->
  forall y, In y (addc x l) <-> In y (addc x l').
Proof.
  intros H y. unfold addc. rewrite (memb_seq x l l' H).
  destruct (ceqb x Tp), (memb x l'); simpl; rewrite ?H; tauto.
Qed.

Lemma remc_seq x l l' : (forall y, In y l <-> In y l') ->
  forall y, In y (remc x l) <-> In y (remc x l').
Proof. intros H y. rewrite !in_remc. rewrite H. tauto. Qed.

Lemma smark_seq t t' : SEq t t' -> SEq (smark t) (smark t').
Proof.
  intros [H1 [H2 H3]]. split; [simpl; exact H1|]. split; [simpl; congruence|]. simpl.
  rewrite H3. apply map_ext. intros j. rewrite (memb_seq _ _ _ H1). reflexivity.
Qed.

Lemma sstep_seq t t' o : SEq t t' -> SEq (sstep t o) (sstep t' o).
Proof.
  intros HE. pose proof HE as [H1 [H2 H3]]. unfold sstep. apply smark_seq.
  destruct o as [a b|c d x|c d x]; simpl.
  - split; auto.
  - split; [|split; auto]. rewrite H2. apply addc_seq, remc_seq, H1.
  - split; [|split; auto]. rewrite H2. apply addc_seq, H1.
Qed.

Lemma valid_seq t t' o : SEq t t' -> valid t o -> valid t' o.
Proof.
  intros [H1 _] V. unfold opnd in *.
  assert (K : forall x, x = Tp \/ In x (sA t) -> x = Tp \/ In x (sA t')) by (intros x [E|E]; [now left|right; apply H1, E]).
  destruct o; simpl in *; [destruct V as [V1 V2]; split; apply K; auto|
    destruct V as [V0 [V1 V2]]; split; [auto|split; apply K; auto]..].
Qed.

Lemma sgood_seq t t' b : SEq t t' -> sgood t b -> sgood t' b.
Proof.
  intros HE G. revert t' HE. induction G as [t b D|t b o V G IH]; intros t' HE.
  - apply sg_done. destruct HE as [_ [_ H3]]. intros j Hj. rewrite H3. apply D; auto.
  - apply sg_step; [eapply valid_seq; eauto|]. apply IH. apply sstep_seq, HE.
Qed.

(* ---------- flag polarity ---------- *)
Variable negp : F -> F.
Hypothesis negp_spec : forall f, decf (negp f) = map CompOpp (decf f).

Definition negS (t : sst) : sst := SS (sA t) (negp (sf t)) (sdn t).

Definition negop (o : sop) : sop :=
  match o with SCmp a b => SCmp b a | SIn c d x => SIn (swapc c) d x | SCopy c d x => SCopy (swapc c) d x end.

Lemma cmpp_swap a b : cmpp b a = negp (cmpp a b).
Proof. apply decf_inj. rewrite negp_spec, !cmpp_spec. apply cmpcol_swap. Qed.

Lemma blendp_neg c f a b : blendp (swapc c) (negp f) a b = blendp c f a b.
Proof.
  apply dec_inj. rewrite !blendp_spec, negp_spec.
  pose proof (blend_neg c true (decf f) (dec a) (dec b)) as E. simpl in E.
  replace (map CompOpp (decf f)) with (map (negc true) (decf f)) by reflexivity. exact E.
Qed.

Lemma sstep_neg t o : sstep (negS t) (negop o) = negS (sstep t o).
Proof.
  destruct t as [A f dn].
  destruct o as [a b|c d x|c d x]; cbn [negop]; unfold sstep, smark, negS; cbn [sA sf sdn].
  - rewrite (cmpp_swap a b). reflexivity.
  - rewrite blendp_neg. reflexivity.
  - rewrite blendp_neg. reflexivity.
Qed.

Lemma sgood_neg t b : sgood t b -> sgood (negS t) b.
Proof.
  induction 1 as [t b D|t b o V G IH].
  - apply sg_done. exact D.
  - replace (cost o) with (cost (negop o)) by (destruct o; reflexivity).
    apply sg_step.
    + destruct o; simpl in *; unfold opnd in *; simpl; try rewrite Hsym; tauto.
    + rewrite sstep_neg. exact IH.
Qed.


(* ---------- set-level prune rules ---------- *)
Lemma tgt_val j w : j < n -> w < W -> nth w (tgt reps j) 0 < n.
Proof.
  intros Hj Hw. rewrite (tgt_row n reps w j Hw Hj). set (rep := nth w reps []).
  assert (Hr : length rep = n /\ (forall v, In v rep -> v < n)) by (apply Hreps, nth_In; lia).
  apply Hr. eapply Permutation_in; [apply Permutation_sym, NatSort.Permuted_sort|]. apply nth_In.
  rewrite <- (Permutation_length (NatSort.Permuted_sort rep)). lia.
Qed.

Lemma blendp_row c f a b w : w < W ->
  nth w (dec (blendp c f a b)) 0 = if cond_eval c (nth w (decf f) Eq) then nth w (dec b) 0 else nth w (dec a) 0.
Proof. intros Hw. rewrite blendp_spec. apply blend_nth; rewrite ?dec_len, ?decf_len; auto. Qed.

Lemma opnd_row t x w : w < W -> opnd t x -> x = Tp \/ In x (sA t).
Proof. intros _ H. exact H. Qed.

Lemma Tp_row w : w < W -> nth w (dec Tp) 0 = n.
Proof. intros Hw. rewrite Tp_spec. apply nth_repeat_lt. lia. Qed.

Lemma in_sstep t o y : In y (sA (sstep t o)) -> In y (sA t) \/
  (exists c d x, (o = SIn c d x \/ o = SCopy c d x) /\ y = blendp c (sf t) d x).
Proof.
  unfold sstep, smark; simpl. destruct o as [a b|c d x|c d x]; simpl; intros H; auto.
  - apply in_addc in H as [H|H]; [apply in_remc in H as [H _]; auto|right; exists c, d, x; auto].
  - apply in_addc in H as [H|H]; auto. right; exists c, d, x; auto.
Qed.

Definition absentS (t : sst) (w v : nat) : Prop := forall a, In a (sA t) -> nth w (dec a) 0 <> v.

Lemma absentS_step t o w v : w < W -> v < n -> valid t o -> absentS t w v -> absentS (sstep t o) w v.
Proof.
  intros Hw Hv V Ha y Hy. apply in_sstep in Hy as [Hy|[c [d [x [Ho ->]]]]]; [apply Ha; auto|].
  assert (Od : opnd t d /\ opnd t x) by (destruct Ho as [->| ->]; simpl in V; tauto).
  rewrite blendp_row by auto. destruct Od as [[Od|Od] [Ox|Ox]];
  destruct (cond_eval _ _); subst; rewrite ?Tp_row by auto; try lia; apply Ha; auto.
Qed.

Lemma dead_sound t b : sgood t b -> forall w j, w < W -> j < n -> nth j (sdn t) false = false ->
  absentS t w (nth w (tgt reps j) 0) -> False.
Proof.
  induction 1 as [t b D|t b o V G IH]; intros w j Hw Hj Hu Ha.
  - rewrite D in Hu; auto. discriminate.
  - apply (IH w j); auto.
    + unfold sstep, smark; simpl. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
      rewrite seq_nth by auto. simpl. destruct o; simpl; rewrite Hu;
      (destruct (memb _ _) eqn:M; auto; apply memb_spec in M; exfalso;
       pose proof (absentS_step t _ w _ Hw (tgt_val j w Hj Hw) V Ha) as A';
       apply (A' _ M); rewrite tgp_spec; auto).
    + apply absentS_step; auto. apply tgt_val; auto.
Qed.

(* number of undone outputs <= cost of the non-cmp operations left *)
Definition undone (t : sst) : nat := length (filter (fun j => negb (nth j (sdn t) false)) (seq 0 n)).
Definition isCmpS (o : sop) : bool := match o with SCmp _ _ => true | _ => false end.
Definition ncost (os : list sop) : nat := fold_right (fun o a => (if isCmpS o then 0 else cost o) + a) 0 os.
Definition ncmpS (os : list sop) : nat := length (filter isCmpS os).

Lemma costs_split os : costs os = ncmpS os + ncost os.
Proof. induction os as [|o os IH]; simpl; auto. unfold ncmpS in *. destruct o; simpl; lia. Qed.

Lemma sstep_dn t o j : j < n -> nth j (sdn (sstep t o)) false =
  if nth j (sdn t) false then true else memb (nth j tgp Tp) (sA (sstep t o)).
Proof.
  intros Hj. unfold sstep, smark; simpl. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
  rewrite seq_nth by auto. destruct o; reflexivity.
Qed.

Lemma filter_split_le (f g : nat -> bool) l :
  length (filter f l) <= length (filter g l) + length (filter (fun j => f j && negb (g j)) l).
Proof. induction l as [|a l IH]; simpl; [lia|]. destruct (f a), (g a); simpl; lia. Qed.

Lemma undone_step t o : smarked t -> undone t <= undone (sstep t o) + (if isCmpS o then 0 else 1).
Proof.
  intros Hm. unfold undone.
  eapply Nat.le_trans; [apply (filter_split_le _ (fun j => negb (nth j (sdn (sstep t o)) false)))|].
  apply Nat.add_le_mono_l.
  set (L := filter _ (seq 0 n)).
  assert (HL : forall j, In j L -> j < n /\ nth j (sdn t) false = false /\ memb (nth j tgp Tp) (sA (sstep t o)) = true).
  { intros j Hj. unfold L in Hj. apply filter_In in Hj as [Hj E]. apply in_seq in Hj.
    apply andb_true_iff in E as [E1 E2]. apply negb_true_iff in E1. rewrite negb_involutive in E2.
    rewrite sstep_dn, E1 in E2 by lia. split; [lia|]. auto. }
  assert (New : forall j, In j L -> exists c d x, (o = SIn c d x \/ o = SCopy c d x) /\ nth j tgp Tp = blendp c (sf t) d x).
  { intros j Hj. destruct (HL j Hj) as [Hjn [Hu Hmb]]. apply memb_spec in Hmb.
    apply in_sstep in Hmb as [Hin|Hnew]; auto. exfalso. rewrite (Hm j Hjn) in Hu; [discriminate|].
    apply memb_spec; auto. }
  destruct (isCmpS o) eqn:Ec.
  - destruct L as [|j L']; simpl; [lia|]. exfalso. destruct (New j (or_introl eq_refl)) as [c [d [x [[->| ->] _]]]];
    discriminate.
  - apply len_le_one; [apply NoDup_filter, seq_NoDup|]. intros j1 j2 H1 H2.
    destruct (New j1 H1) as [c1 [d1 [x1 [O1 E1]]]]. destruct (New j2 H2) as [c2 [d2 [x2 [O2 E2]]]].
    destruct (HL j1 H1) as [Hj1 _]. destruct (HL j2 H2) as [Hj2 _].
    apply Htd; auto. rewrite <- !tgp_spec by auto. f_equal.
    rewrite E1, E2. destruct O1 as [->| ->], O2 as [O2|O2]; inversion O2; subst; reflexivity.
Qed.

Lemma sstep_marked' t o : smarked (sstep t o).
Proof. apply sstep_marked. Qed.

Lemma undone_ops t os : smarked t -> sdone (srun t os) -> undone t <= ncost os.
Proof.
  revert t; induction os as [|o os IH]; intros t Hm D; simpl in *.
  - unfold undone. rewrite (filter_ext_in _ (fun _ => false)).
    + clear. induction (seq 0 n); simpl; auto.
    + intros j Hj. apply in_seq in Hj. rewrite D by lia. reflexivity.
  - pose proof (undone_step t o Hm). specialize (IH (sstep t o) (sstep_marked t o) D).
    destruct o; simpl in *; lia.
Qed.

(* ---------- H1: classes of strict inputs ---------- *)
Variable strict : list nat.
Hypothesis Hstrict : forall w, In w strict ->
  w < W /\ NoDup (nth w reps []) /\ NatSort.sort (nth w reps []) = seq 0 n.
Hypothesis Hsdist : forall w1 w2, In w1 strict -> In w2 strict -> nth w1 reps [] = nth w2 reps [] -> w1 = w2.
Hypothesis HsND : NoDup strict.

Definition idxS (w v : nat) : nat := idx n reps w v.

Definition keyS (t : sst) (w : nat) : list nat :=
  fcode (nth w (decf (sf t)) Eq) :: map (fun a => idxS w (nth w (dec a) 0)) (sA t)
  ++ map (fun j => if nth j (sdn t) false then findpos n j (nth w reps []) else 0) (seq 0 n).

Definition ksimS (t : sst) (w1 w2 : nat) : Prop :=
  nth w1 (decf (sf t)) Eq = nth w2 (decf (sf t)) Eq /\
  (forall a, In a (sA t) -> idxS w1 (nth w1 (dec a) 0) = idxS w2 (nth w2 (dec a) 0)) /\
  (forall j, j < n -> nth j (sdn t) false = true -> findpos n j (nth w1 reps []) = findpos n j (nth w2 reps [])).

Lemma key_ksimS t w1 w2 : keyS t w1 = keyS t w2 -> ksimS t w1 w2.
Proof.
  unfold keyS. intros E. inversion E as [[E1 E2]].
  apply app_len_inj in E2 as [E2 E3]; [|now rewrite !length_map].
  split; [now apply fcode_inj|]. split.
  - intros a Ha. apply In_nth with (d := Tp) in Ha as [k [Hk Ek]].
    assert (A : forall w, nth k (map (fun a => idxS w (nth w (dec a) 0)) (sA t)) 0 = idxS w (nth w (dec a) 0)).
    { intros w. rewrite (nth_map_lt _ _ _ _ Tp) by auto. now rewrite Ek. }
    rewrite <- (A w1), <- (A w2). now rewrite E2.
  - intros j Hj D.
    assert (A : forall w, nth j (map (fun j => if nth j (sdn t) false then findpos n j (nth w reps []) else 0)
                                     (seq 0 n)) 0 = findpos n j (nth w reps [])).
    { intros w. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto). rewrite seq_nth by auto.
      simpl. now rewrite D. }
    rewrite <- (A w1), <- (A w2). now rewrite E3.
Qed.

Definition ltbit (f : F) (w : nat) : bool := match nth w (decf f) Eq with Lt => true | _ => false end.

Lemma idxS_T w : idxS w n = n.
Proof. unfold idxS, idx. now rewrite Nat.eqb_refl. Qed.

Lemma opnd_idx t x w1 w2 : w1 < W -> w2 < W -> ksimS t w1 w2 -> opnd t x ->
  idxS w1 (nth w1 (dec x) 0) = idxS w2 (nth w2 (dec x) 0).
Proof.
  intros H1 H2 [_ [K _]] [->|Hx]; [rewrite !Tp_row, !idxS_T by auto; reflexivity|auto].
Qed.

Lemma strict_tgt w j : In w strict -> j < n -> nth w (tgt reps j) 0 = j.
Proof.
  intros Hw Hj. destruct (Hstrict w Hw) as [Hw' [_ Hs]]. rewrite (tgt_row n reps w j Hw' Hj), Hs.
  apply seq_nth; auto.
Qed.

Lemma ksimS_step t o w1 w2 : In w1 strict -> In w2 strict -> valid t o -> ksimS t w1 w2 ->
  (isCmpS o = true -> ltbit (sf (sstep t o)) w1 = ltbit (sf (sstep t o)) w2) ->
  ksimS (sstep t o) w1 w2.
Proof.
  intros I1 I2 V K Hb. pose proof (proj1 (Hstrict w1 I1)) as W1. pose proof (proj1 (Hstrict w2 I2)) as W2.
  assert (Kc : forall a, In a (sA (sstep t o)) -> idxS w1 (nth w1 (dec a) 0) = idxS w2 (nth w2 (dec a) 0)).
  { intros y Hy. apply in_sstep in Hy as [Hy|[c [d [x [Ho ->]]]]]; [apply K; auto|].
    assert (Od : opnd t d /\ opnd t x) by (destruct Ho as [->| ->]; simpl in V; tauto).
    rewrite !blendp_row by auto. pose proof K as [Kf _]. rewrite Kf.
    destruct (cond_eval _ _); apply (opnd_idx t); tauto. }
  split; [|split; auto].
  - destruct o as [a b|c d x|c d x]; unfold sstep, smark; simpl; try apply K.
    specialize (Hb eq_refl). unfold ltbit in Hb. unfold sstep, smark in Hb; simpl in Hb.
    destruct V as [Oa Ob].
    rewrite !cmpp_spec in *. rewrite !cmpcol_nth in Hb |- * by (rewrite dec_len; auto).
    pose proof (opnd_idx t a w1 w2 W1 W2 K Oa) as Ea. pose proof (opnd_idx t b w1 w2 W1 W2 K Ob) as Eb.
    assert (Iff : nth w1 (dec a) 0 = nth w1 (dec b) 0 <-> nth w2 (dec a) 0 = nth w2 (dec b) 0).
    { split; intros E.
      - apply (idx_inj n reps Hreps w2); auto. unfold idxS in *. rewrite <- Ea, <- Eb, E. reflexivity.
      - apply (idx_inj n reps Hreps w1); auto. unfold idxS in *. rewrite Ea, Eb, E. reflexivity. }
    destruct (Nat.compare_spec (nth w1 (dec a) 0) (nth w1 (dec b) 0)),
             (Nat.compare_spec (nth w2 (dec a) 0) (nth w2 (dec b) 0)); auto; try discriminate;
      try (apply Iff in H; lia); try (apply Iff in H0; lia).
  - intros j Hj D. rewrite sstep_dn in D by auto.
    destruct (nth j (sdn t) false) eqn:Dj; [apply K; auto|].
    apply memb_spec in D. specialize (Kc _ D). rewrite !tgp_spec, !strict_tgt in Kc by auto.
    unfold idxS, idx in Kc. destruct (Nat.eqb_spec j n); [lia|exact Kc].
Qed.

Fixpoint bitsS (os : list sop) (t : sst) (w : nat) : list bool :=
  match os with
  | [] => []
  | o :: os' => if isCmpS o then ltbit (sf (sstep t o)) w :: bitsS os' (sstep t o) w else bitsS os' (sstep t o) w
  end.

Lemma bitsS_len os t w : length (bitsS os t w) = ncmpS os.
Proof. unfold ncmpS. revert t; induction os as [|o os IH]; simpl; intros; auto. destruct (isCmpS o); simpl; auto. Qed.

Lemma ksimS_run os t w1 w2 : In w1 strict -> In w2 strict -> vseq t os -> ksimS t w1 w2 ->
  bitsS os t w1 = bitsS os t w2 -> ksimS (srun t os) w1 w2.
Proof.
  revert t; induction os as [|o os IH]; simpl; intros t I1 I2 V K B; auto.
  destruct V as [V1 V2]. destruct (isCmpS o) eqn:E.
  - inversion B as [[B1 B2]]. apply IH; auto. apply ksimS_step; auto.
  - apply IH; auto. apply ksimS_step; auto. congruence.
Qed.

Lemma ksimS_goal t w1 w2 : In w1 strict -> In w2 strict -> sdone t -> ksimS t w1 w2 -> w1 = w2.
Proof.
  intros I1 I2 D [_ [_ K]].
  destruct (Hstrict w1 I1) as [W1 [N1 S1]]. destruct (Hstrict w2 I2) as [W2 [N2 S2]].
  apply Hsdist; auto.
  set (rep1 := nth w1 reps []) in *. set (rep2 := nth w2 reps []) in *.
  assert (Hr1 : length rep1 = n /\ (forall v, In v rep1 -> v < n)) by (apply Hreps, nth_In; auto).
  assert (Hr2 : length rep2 = n /\ (forall v, In v rep2 -> v < n)) by (apply Hreps, nth_In; auto).
  assert (Fp : forall v, v < n -> findpos n v rep1 = findpos n v rep2) by (intros v Hv; apply K; auto).
  apply nth_ext with (d := 0) (d' := 0); [lia|].
  intros i Hi. set (v := nth i rep1 0).
  assert (Hv : v < n) by (apply Hr1, nth_In; auto).
  assert (P1 : findpos n v rep1 = i) by (apply (findpos_nodup n reps); auto).
  rewrite Fp in P1 by auto.
  destruct (findpos_cases n reps v rep2) as [[_ [_ Bq]]|[_ A]]; [|lia].
  rewrite P1 in Bq. auto.
Qed.

Lemma class_boundS t os G : vseq t os -> sdone (srun t os) ->
  NoDup G -> incl G strict -> (forall w1 w2, In w1 G -> In w2 G -> ksimS t w1 w2) ->
  length G <= 2 ^ ncmpS os.
Proof.
  intros V D ND Hinc K.
  rewrite <- (all_bools_len reps), <- (length_map (fun w => bitsS os t w) G).
  apply NoDup_incl_length.
  - apply NoDup_map_inj; auto. intros x y Hx Hy E.
    apply (ksimS_goal (srun t os)); auto. apply ksimS_run; auto.
  - intros l Hl. apply in_map_iff in Hl as [w [<- _]].
    rewrite <- (bitsS_len os t w). apply all_bools_in.
Qed.

(* H2: a shortest program has no useless cmp, so #cmp <= #non-cmp operations *)
Fixpoint red (t : sst) (os : list sop) : list sop :=
  match os with
  | [] => []
  | SCmp a b :: r =>
      match r with
      | [] => []
      | SCmp _ _ :: _ => red t r
      | _ => SCmp a b :: red (sstep t (SCmp a b)) r
      end
  | o :: r => o :: red (sstep t o) r
  end.

Definition nnonS (os : list sop) : nat := length (filter (fun o => negb (isCmpS o)) os).

Lemma smark_dn_ext t t' : sA t = sA t' -> sf t = sf t' ->
  (forall j, j < n -> nth j (sdn t) false = nth j (sdn t') false) -> smark t = smark t'.
Proof.
  intros H1 H2 H3. unfold smark. rewrite H1, H2. f_equal. apply map_ext_in. intros j Hj. apply in_seq in Hj.
  rewrite H3 by lia. reflexivity.
Qed.

Lemma cmp_cmp t a b c d : smarked t -> sstep (sstep t (SCmp a b)) (SCmp c d) = sstep t (SCmp c d).
Proof.
  intros M.
  transitivity (smark (SS (sA t) (cmpp c d) (sdn (sstep t (SCmp a b))))); [reflexivity|].
  transitivity (smark (SS (sA t) (cmpp c d) (sdn t))); [|reflexivity].
  apply smark_dn_ext; try reflexivity. intros j Hj. cbn [sdn].
  rewrite sstep_dn by auto. destruct (nth j (sdn t) false) eqn:E; auto.
  destruct (memb _ _) eqn:Q; auto. rewrite (M j Hj Q) in E. discriminate.
Qed.

Lemma cmp_done t a b : smarked t -> sdone (sstep t (SCmp a b)) -> sdone t.
Proof.
  intros M D j Hj. specialize (D j Hj). rewrite sstep_dn in D by auto.
  destruct (nth j (sdn t) false) eqn:E; auto. rewrite <- E. apply (M j Hj). exact D.
Qed.

Lemma red_ok os : forall t, smarked t -> vseq t os -> sdone (srun t os) ->
  vseq t (red t os) /\ sdone (srun t (red t os)) /\ costs (red t os) <= costs os.
Proof.
  induction os as [|o os IH]; intros t M V D; [simpl; auto|].
  destruct V as [V1 V2].
  destruct o as [a b|c d x|c d x].
  - destruct os as [|o2 os2].
    + simpl in *. split; auto. split; [apply (cmp_done t a b M D)|lia].
    + destruct o2 as [a2 b2|c2 d2 x2|c2 d2 x2].
      * (* cmp followed by cmp: drop the first *)
        destruct V2 as [V3 V4]. simpl in D. rewrite cmp_cmp in D, V4 by auto.
        assert (V' : vseq t (SCmp a2 b2 :: os2)).
        { split; [exact V3|exact V4]. }
        destruct (IH t M V' D) as [R1 [R2 R3]]. simpl red. split; [exact R1|]. split; [exact R2|].
        simpl costs in *. lia.
      * destruct (IH (sstep t (SCmp a b)) (sstep_marked t _) V2 D) as [R1 [R2 R3]].
        simpl. split; [split; auto|]. split; [exact R2|]. simpl in R3. lia.
      * destruct (IH (sstep t (SCmp a b)) (sstep_marked t _) V2 D) as [R1 [R2 R3]].
        simpl. split; [split; auto|]. split; [exact R2|]. simpl in R3. lia.
  - destruct (IH (sstep t _) (sstep_marked t _) V2 D) as [R1 [R2 R3]]. simpl. split; [split; auto|]. split; auto. lia.
  - destruct (IH (sstep t _) (sstep_marked t _) V2 D) as [R1 [R2 R3]]. simpl. split; [split; auto|]. split; auto. lia.
Qed.

Lemma red_head t o os : isCmpS o = false -> exists r, red t (o :: os) = o :: r.
Proof. destruct o; simpl; try discriminate; eauto. Qed.

Lemma red_cmp_le_aux m : forall os t, length os <= m -> ncmpS (red t os) <= nnonS (red t os).
Proof.
  induction m as [|m IH]; intros os t L.
  { destruct os; [unfold ncmpS, nnonS; simpl; lia|simpl in L; lia]. }
  destruct os as [|o os]; [unfold ncmpS, nnonS; simpl; lia|]. simpl in L.
  destruct o as [a b|c d x|c d x].
  - destruct os as [|o2 os2]; [unfold ncmpS, nnonS; simpl; lia|].
    destruct o2 as [a2 b2|c2 d2 x2|c2 d2 x2].
    + change (red t (SCmp a b :: SCmp a2 b2 :: os2)) with (red t (SCmp a2 b2 :: os2)). apply IH. simpl in *. lia.
    + simpl red. assert (H := IH os2 (sstep (sstep t (SCmp a b)) (SIn c2 d2 x2)) ltac:(simpl in L; lia)).
      unfold ncmpS, nnonS in *. simpl. lia.
    + simpl red. assert (H := IH os2 (sstep (sstep t (SCmp a b)) (SCopy c2 d2 x2)) ltac:(simpl in L; lia)).
      unfold ncmpS, nnonS in *. simpl. lia.
  - simpl. assert (H := IH os (sstep t (SIn c d x)) ltac:(lia)). unfold ncmpS, nnonS in *. simpl. lia.
  - simpl. assert (H := IH os (sstep t (SCopy c d x)) ltac:(lia)). unfold ncmpS, nnonS in *. simpl. lia.
Qed.

Lemma red_cmp_le os t : ncmpS (red t os) <= nnonS (red t os).
Proof. apply (red_cmp_le_aux (length os)). lia. Qed.

Lemma nnon_ncost os : nnonS os <= ncost os.
Proof. induction os as [|o os IH]; simpl; auto. unfold nnonS in *. destruct o; simpl; lia. Qed.


(* ---------- H3': covers of an undone target ---------- *)
Definition covers (S : list C) (j : nat) : Prop := forall w, In w strict -> exists a, In a S /\ nth w (dec a) 0 = j.
Definition covm (A : list C) (j m : nat) : Prop := exists S, incl S A /\ length S <= m /\ covers S j.

Definition jusefb (M : C) (j : nat) : bool := existsb (fun w => Nat.eqb (nth w (dec M) 0) j) strict.

Definition newcol (t : sst) (o : sop) : option C :=
  match o with SCmp _ _ => None | SIn c d x | SCopy c d x => Some (blendp c (sf t) d x) end.

Definition usestep (t : sst) (o : sop) (j : nat) : bool :=
  match newcol t o with Some M => jusefb M j | None => false end.

Lemma in_sstep' t o y : In y (sA (sstep t o)) -> In y (sA t) \/ newcol t o = Some y.
Proof.
  intros H. apply in_sstep in H as [H|[c [d [x [Ho ->]]]]]; auto. right.
  destruct Ho as [->| ->]; reflexivity.
Qed.

Lemma covm_mono A j m m' : covm A j m -> m <= m' -> covm A j m'.
Proof. intros [S [H1 [H2 H3]]] Hm. exists S. split; auto. split; auto. lia. Qed.

Lemma covm_notuse t o j m : covm (sA (sstep t o)) j m -> usestep t o j = false -> covm (sA t) j m.
Proof.
  intros [S [Hi [Hl Hc]]] Hu. exists (filter (fun a => memb a (sA t)) S). split; [|split].
  - intros a Ha. apply filter_In in Ha as [_ Ha]. apply memb_spec, Ha.
  - eapply Nat.le_trans; [|exact Hl]. clear. induction S as [|a S IH]; simpl; auto. destruct (memb a _); simpl; lia.
  - intros w Hw. destruct (Hc w Hw) as [a [Ha Ea]]. exists a. split; auto. apply filter_In. split; auto.
    apply memb_spec. destruct (in_sstep' t o a (Hi a Ha)) as [H|H]; auto. exfalso.
    unfold usestep in Hu. rewrite H in Hu. unfold jusefb in Hu.
    assert (existsb (fun w => Nat.eqb (nth w (dec a) 0) j) strict = true)
      by (apply existsb_exists; exists w; split; auto; apply Nat.eqb_eq, Ea).
    congruence.
Qed.

Lemma forallb_false' {A} (f : A -> bool) l : forallb f l = false -> exists x, In x l /\ f x = false.
Proof.
  induction l as [|a l IH]; simpl; [discriminate|]. intros H.
  destruct (f a) eqn:E; simpl in H; [destruct (IH H) as [x [? ?]]; eauto|eauto].
Qed.

Lemma filter_len_lt {A} (f : A -> bool) l : (exists a, In a l /\ f a = false) -> length (filter f l) < length l.
Proof.
  induction l as [|b l IH]; simpl; intros [a [Ha Fa]]; [destruct Ha|].
  pose proof (filter_length_le f l) as L.
  destruct Ha as [<-|Ha]; [rewrite Fa; simpl; lia|].
  assert (length (filter f l) < length l) by (apply IH; eauto). destruct (f b); simpl; lia.
Qed.

Lemma covm_use t o j m : valid t o -> covm (sA (sstep t o)) j m -> j < n -> covm (sA t) j (S m).
Proof.
  intros V [S [Hi [Hl Hc]]] Hj.
  destruct (forallb (fun a => memb a (sA t)) S) eqn:Fa.
  - exists S. split; [|split; [lia|exact Hc]]. intros a Ha. rewrite forallb_forall in Fa. apply memb_spec, Fa, Ha.
  - apply forallb_false' in Fa as [a0 [Ha0 Fa0]].
    destruct (in_sstep' t o a0 (Hi a0 Ha0)) as [H0|H0]; [apply memb_spec in H0; congruence|].
    destruct o as [a b|c d x|c d x]; simpl in H0; try discriminate. all: injection H0 as H0.
    all: set (keep := fun y => memb y (sA t)).
    all: exists (filter keep S ++ filter keep [d; x]).
    all: split; [intros y Hy; apply in_app_iff in Hy as [Hy|Hy]; apply filter_In in Hy as [_ Hy]; apply memb_spec, Hy|].
    all: split; [rewrite length_app;
                 assert (length (filter keep S) < length S) by (apply filter_len_lt; exists a0; split; auto);
                 pose proof (filter_length_le keep [d; x]); simpl in *; lia|].
    all: intros w Hw; pose proof (proj1 (Hstrict w Hw)) as Ww; destruct (Hc w Hw) as [a [Ha Ea]].
    all: destruct (memb a (sA t)) eqn:Ma; [exists a; split; [apply in_or_app; left; apply filter_In; auto|auto]|].
    all: destruct (in_sstep' _ _ a (Hi a Ha)) as [Q|Q]; [apply memb_spec in Q; congruence|].
    all: simpl in Q; injection Q as Q; subst a; rewrite blendp_row in Ea by auto.
    all: simpl in V; destruct V as [_ [Od Ox]].
    all: destruct (cond_eval _ _) in Ea;
         [assert (Hz : In x (sA t)) by (destruct Ox as [Ox|Ox]; [rewrite Ox, Tp_row in Ea by auto; lia|auto]);
          exists x|
          assert (Hz : In d (sA t)) by (destruct Od as [Od|Od]; [rewrite Od, Tp_row in Ea by auto; lia|auto]);
          exists d];
         (split; [apply in_or_app; right; apply filter_In; split; [simpl; auto|apply memb_spec, Hz]|exact Ea]).
Qed.

Fixpoint nuse (t : sst) (os : list sop) (j : nat) : nat :=
  match os with [] => 0 | o :: r => (if usestep t o j then 1 else 0) + nuse (sstep t o) r j end.

Lemma covm_tgt t j : j < n -> In (nth j tgp Tp) (sA t) -> covm (sA t) j 1.
Proof.
  intros Hj H. exists [nth j tgp Tp]. split; [intros y [<-|[]]; auto|]. split; [simpl; lia|].
  intros w Hw. exists (nth j tgp Tp). split; [now left|]. rewrite tgp_spec by auto. apply strict_tgt; auto.
Qed.

Lemma nuse_bound j os : forall t m, j < n -> vseq t os -> ~ covm (sA t) j m ->
  (exists i, i <= length os /\ In (nth j tgp Tp) (sA (srun t (firstn i os)))) -> m <= nuse t os j.
Proof.
  induction os as [|o os IH]; intros t m Hj V Nc [i [Hi Hin]].
  - simpl in Hi. assert (i = 0) by lia. subst. simpl in Hin. destruct m as [|m]; [lia|].
    exfalso. apply Nc. apply covm_mono with 1; [apply covm_tgt; auto|lia].
  - destruct i as [|i].
    + simpl in Hin. destruct m as [|m]; [lia|]. exfalso. apply Nc. apply covm_mono with 1; [apply covm_tgt; auto|lia].
    + destruct V as [V1 V2]. simpl in Hi, Hin. simpl nuse.
      destruct (usestep t o j) eqn:U.
      * destruct m as [|m]; [lia|].
        assert (m <= nuse (sstep t o) os j); [|lia].
        apply IH; auto; [|exists i; split; [lia|auto]].
        intros Hc. apply Nc. apply (covm_use t o j m V1 Hc Hj).
      * apply IH; auto; [|exists i; split; [lia|auto]].
        intros Hc. apply Nc. apply (covm_notuse t o j m Hc U).
Qed.

Definition undj (t : sst) (j : nat) : nat :=
  length (filter (fun k => negb (Nat.eqb k j) && negb (nth k (sdn t) false)) (seq 0 n)).

Lemma undj_step t o j : smarked t -> j < n ->
  undj t j <= undj (sstep t o) j + (if isCmpS o then 0 else if usestep t o j then 0 else 1).
Proof.
  intros Hm Hj. unfold undj.
  eapply Nat.le_trans; [apply (filter_split_le _ (fun k => negb (Nat.eqb k j) && negb (nth k (sdn (sstep t o)) false)))|].
  apply Nat.add_le_mono_l.
  set (L := filter _ (seq 0 n)).
  assert (HL : forall k, In k L -> k < n /\ k <> j /\ nth k (sdn t) false = false /\ memb (nth k tgp Tp) (sA (sstep t o)) = true).
  { intros k Hk. unfold L in Hk. apply filter_In in Hk as [Hk E]. apply in_seq in Hk.
    apply andb_true_iff in E as [E1 E2]. apply andb_true_iff in E1 as [E0 E1].
    apply negb_true_iff in E0, E1. rewrite E0 in E2. cbn [negb andb] in E2.
    apply Nat.eqb_neq in E0.
    rewrite sstep_dn, E1 in E2 by lia. rewrite negb_involutive in E2. repeat split; auto; lia. }
  assert (New : forall k, In k L -> newcol t o = Some (nth k tgp Tp)).
  { intros k Hk. destruct (HL k Hk) as [Hkn [_ [Hu Hmb]]]. apply memb_spec in Hmb.
    destruct (in_sstep' t o _ Hmb) as [Hin|Hnew]; auto. exfalso. rewrite (Hm k Hkn) in Hu; [discriminate|].
    apply memb_spec; auto. }
  destruct (isCmpS o) eqn:Ec.
  - destruct L as [|k L']; simpl; [lia|]. exfalso. specialize (New k (or_introl eq_refl)).
    destruct o; simpl in Ec, New; discriminate.
  - destruct (usestep t o j) eqn:U.
    + destruct L as [|k L']; simpl; [lia|]. exfalso. destruct (HL k (or_introl eq_refl)) as [Hkn [Hkj _]].
      specialize (New k (or_introl eq_refl)). unfold usestep in U. rewrite New in U. unfold jusefb in U.
      apply existsb_exists in U as [w [Hw E]]. apply Nat.eqb_eq in E.
      rewrite tgp_spec, strict_tgt in E by auto. lia.
    + apply len_le_one; [apply NoDup_filter, seq_NoDup|]. intros k1 k2 H1 H2.
      destruct (HL k1 H1) as [Hk1 _]. destruct (HL k2 H2) as [Hk2 _].
      apply Htd; auto. rewrite <- !tgp_spec by auto. f_equal. pose proof (New k1 H1). pose proof (New k2 H2). congruence.
Qed.

Lemma nnon_h3 j os : forall t, j < n -> smarked t -> vseq t os -> sdone (srun t os) ->
  nuse t os j + undj t j <= nnonS os.
Proof.
  induction os as [|o os IH]; intros t Hj Hm V D.
  - simpl in *. unfold undj. rewrite (filter_ext_in _ (fun _ => false)).
    + clear. unfold nnonS. simpl. induction (seq 0 n); simpl; auto.
    + intros k Hk. apply in_seq in Hk. rewrite D by lia. rewrite andb_false_r. reflexivity.
  - destruct V as [V1 V2]. simpl in D. specialize (IH (sstep t o) Hj (sstep_marked t o) V2 D).
    pose proof (undj_step t o j Hm Hj) as U. simpl nuse. unfold nnonS in *. simpl.
    destruct (isCmpS o) eqn:Ec; simpl.
    + assert (usestep t o j = false) by (destruct o; simpl in Ec; try discriminate; reflexivity). rewrite H. lia.
    + destruct (usestep t o j); simpl in *; lia.
Qed.

Lemma reach_tgt t os j : j < n -> smarked t -> nth j (sdn t) false = false -> sdone (srun t os) ->
  exists i, i <= length os /\ In (nth j tgp Tp) (sA (srun t (firstn i os))).
Proof.
  revert t. induction os as [|o os IH]; intros t Hj Hm Hu D.
  - simpl in D. rewrite D in Hu by auto. discriminate.
  - simpl in D. destruct (nth j (sdn (sstep t o)) false) eqn:E.
    + exists 1. split; [simpl; lia|]. simpl. rewrite sstep_dn, Hu in E by auto. apply memb_spec, E.
    + destruct (IH (sstep t o) Hj (sstep_marked t o) E D) as [i [Hi Hin]]. exists (S i). split; [simpl; lia|exact Hin].
Qed.

(* covb: decide covm by enumerating the subsequences of length <= m *)
Fixpoint combs (m : nat) (l : list C) : list (list C) :=
  match l with
  | [] => [[]]
  | a :: l' => combs m l' ++ match m with 0 => [] | S m' => map (cons a) (combs m' l') end
  end.

Definition coversb (S : list C) (j : nat) : bool :=
  forallb (fun w => existsb (fun a => Nat.eqb (nth w (dec a) 0) j) S) strict.

Definition covb (A : list C) (j m : nat) : bool := existsb (fun S => coversb S j) (combs m A).

Lemma combs_spec m l S : In S (combs m l) -> incl S l /\ length S <= m.
Proof.
  revert m S; induction l as [|a l IH]; intros m S H; simpl in H.
  - destruct H as [<-|[]]. split; [intros x []|simpl; lia].
  - apply in_app_iff in H as [H|H].
    + destruct (IH m S H) as [H1 H2]. split; auto. intros x Hx. right. auto.
    + destruct m as [|m]; [destruct H|]. apply in_map_iff in H as [S' [<- H]].
      destruct (IH m S' H) as [H1 H2]. split; [intros x [<-|Hx]; [now left|right; auto]|simpl; lia].
Qed.

Lemma coversb_spec S j : coversb S j = true -> covers S j.
Proof.
  unfold coversb. rewrite forallb_forall. intros H w Hw. specialize (H w Hw).
  apply existsb_exists in H as [a [Ha E]]. exists a. split; auto. apply Nat.eqb_eq, E.
Qed.

Lemma covb_sound A j m : covb A j m = true -> covm A j m.
Proof.
  unfold covb. intros H. apply existsb_exists in H as [S [HS Hc]].
  destruct (combs_spec m A S HS). exists S. split; auto. split; auto. apply coversb_spec, Hc.
Qed.

Definition dedupC (l : list C) : list C := fold_right (fun a acc => if memb a acc then acc else a :: acc) [] l.

Lemma dedupC_in l x : In x (dedupC l) <-> In x l.
Proof.
  induction l as [|a l IH]; simpl; [tauto|]. destruct (memb a (dedupC l)) eqn:E.
  - apply memb_spec in E. rewrite IH. split; [auto|intros [<-|H]; [apply IH|]; auto].
  - simpl. rewrite IH. tauto.
Qed.

Lemma dedupC_nodup l : NoDup (dedupC l).
Proof.
  induction l as [|a l IH]; simpl; [constructor|]. destruct (memb a (dedupC l)) eqn:E; auto.
  constructor; auto. intros H. apply memb_spec in H. congruence.
Qed.

Lemma filter_in_combs (f : C -> bool) l m : length (filter f l) <= m -> In (filter f l) (combs m l).
Proof.
  revert m; induction l as [|a l IH]; intros m H; simpl in *; [now left|].
  apply in_or_app. destruct (f a); simpl in H.
  - right. destruct m as [|m]; [lia|]. apply in_map. apply IH. lia.
  - left. apply IH, H.
Qed.

Lemma covb_complete A j m : covm A j m -> covb (dedupC A) j m = true.
Proof.
  intros [S [Hi [Hl Hc]]]. unfold covb. apply existsb_exists.
  exists (filter (fun a => memb a S) (dedupC A)). split.
  - apply filter_in_combs. eapply Nat.le_trans; [|exact Hl]. apply NoDup_incl_length.
    + apply NoDup_filter, dedupC_nodup.
    + intros x Hx. apply filter_In in Hx as [_ Hx]. apply memb_spec, Hx.
  - unfold coversb. apply forallb_forall. intros w Hw. destruct (Hc w Hw) as [a [Ha Ea]].
    apply existsb_exists. exists a. split; [|apply Nat.eqb_eq, Ea].
    apply filter_In. split; [apply dedupC_in, Hi, Ha|apply memb_spec, Ha].
Qed.

(* the largest m <= cap such that A has no cover of t_j with m columns (0 if none) *)
Fixpoint nocov (A : list C) (j m : nat) : nat :=
  match m with 0 => 0 | S m' => if covb A j m then nocov A j m' else m end.

Lemma nocov_spec A j cap : nocov (dedupC A) j cap = 0 \/ ~ covm A j (nocov (dedupC A) j cap).
Proof.
  induction cap as [|m IH]; simpl; [now left|]. destruct (covb (dedupC A) j (S m)) eqn:E; auto.
  right. intros Hc. apply covb_complete in Hc. congruence.
Qed.

Definition h3ext (t : sst) (cap : nat) : nat :=
  fold_left (fun acc j => if nth j (sdn t) false then acc else Nat.max acc (nocov (dedupC (sA t)) j cap - 1)) (seq 0 n) 0.

Lemma undone_nnon t os : smarked t -> sdone (srun t os) -> undone t <= nnonS os.
Proof.
  revert t; induction os as [|o os IH]; intros t Hm D; simpl in *.
  - unfold undone. rewrite (filter_ext_in _ (fun _ => false)).
    + clear. induction (seq 0 n); simpl; auto.
    + intros j Hj. apply in_seq in Hj. rewrite D by lia. reflexivity.
  - pose proof (undone_step t o Hm). specialize (IH (sstep t o) (sstep_marked t o) D).
    unfold nnonS in *. destruct o; simpl in *; lia.
Qed.

Lemma undone_undj t j : j < n -> undone t <= S (undj t j).
Proof.
  intros Hj. unfold undone, undj.
  eapply Nat.le_trans; [apply (filter_split_le _ (fun k => negb (Nat.eqb k j) && negb (nth k (sdn t) false)))|].
  assert (length (filter (fun k => negb (nth k (sdn t) false) && negb (negb (Nat.eqb k j) && negb (nth k (sdn t) false)))
           (seq 0 n)) <= 1); [|lia].
  apply len_le_one; [apply NoDup_filter, seq_NoDup|].
  assert (E : forall k, In k (filter (fun k => negb (nth k (sdn t) false) &&
                 negb (negb (Nat.eqb k j) && negb (nth k (sdn t) false))) (seq 0 n)) -> k = j).
  { intros k Hk. apply filter_In in Hk as [_ Hk]. destruct (Nat.eqb k j) eqn:Q; [apply Nat.eqb_eq, Q|].
    destruct (nth k (sdn t) false); simpl in Hk; discriminate. }
  intros k1 k2 H1 H2. rewrite (E k1 H1), (E k2 H2). reflexivity.
Qed.

Lemma fold_max_spec (P : nat -> bool) (g : nat -> nat) l a0 :
  let r := fold_left (fun acc j => if P j then acc else Nat.max acc (g j)) l a0 in
  r = a0 \/ (a0 <= r /\ exists j, In j l /\ P j = false /\ r = g j).
Proof.
  revert a0; induction l as [|j l IH]; intros a0; simpl; [now left|].
  destruct (P j) eqn:E.
  - destruct (IH a0) as [H|[H1 [k [Hk Hk2]]]]; [now left|right; split; auto; exists k; auto].
  - destruct (IH (Nat.max a0 (g j))) as [H|[H1 [k [Hk Hk2]]]].
    + rewrite H. destruct (Nat.max_spec a0 (g j)) as [[_ M]|[_ M]]; rewrite M; [right|left]; auto.
      split; [lia|]. exists j. auto.
    + right. split; [lia|]. exists k. auto.
Qed.

Lemma h3_bound t os cap : smarked t -> vseq t os -> sdone (srun t os) -> undone t + h3ext t cap <= nnonS os.
Proof.
  intros Hm V D. pose proof (undone_nnon t os Hm D) as U.
  unfold h3ext. destruct (fold_max_spec (fun j => nth j (sdn t) false) (fun j => nocov (dedupC (sA t)) j cap - 1)
                          (seq 0 n) 0) as [H|[_ [j [Hj [Hu Hr]]]]]; cbv zeta in *; [rewrite H; lia|].
  rewrite Hr. apply in_seq in Hj.
  set (m := nocov (dedupC (sA t)) j cap) in *.
  destruct (nocov_spec (sA t) j cap) as [Z|Nc]; [fold m in Z; rewrite Z; simpl; lia|]. fold m in Nc.
  pose proof (nuse_bound j os t m ltac:(lia) V Nc (reach_tgt t os j ltac:(lia) Hm Hu D)) as NU.
  pose proof (nnon_h3 j os t ltac:(lia) Hm V D) as NH.
  pose proof (undone_undj t j ltac:(lia)). lia.
Qed.

Definition hcb_e (t : sst) (b e : nat) : bool :=
  let u := undone t in
  let ok c := forallb (fun x => Nat.ltb (2 ^ x) c || Nat.ltb b (x + Nat.max u (Nat.max x (u + e)))) (seq 0 (S b)) in
  ok (length strict) &&
  (let ks := map (keyS t) strict in existsb (fun k => ok (length (filter (col_eqb k) ks))) ks).

Definition h3cap (b : nat) : nat := Nat.min b 8.

Definition hcbS (t : sst) (b : nat) : bool := hcb_e t b 0 || hcb_e t b (h3ext t (h3cap b)).

Definition deadSb (t : sst) : bool :=
  existsb (fun w => existsb (fun j => negb (nth j (sdn t) false) &&
             forallb (fun a => negb (Nat.eqb (nth w (dec a) 0) (nth w (dec (nth j tgp Tp)) 0))) (sA t))
           (seq 0 n)) (seq 0 W).

Definition pruneS (t : sst) (b : nat) : bool := Nat.ltb b (undone t) || deadSb t || hcbS t b.

Lemma hcb_e_sound t b e os : vseq t os -> sdone (srun t os) -> costs os <= b ->
  ncmpS os <= nnonS os -> undone t + e <= nnonS os -> undone t <= nnonS os ->
  hcb_e t b e = true -> False.
Proof.
  intros V D Cs H2 He Hu Hp. pose proof (costs_split os) as Cs2. pose proof (nnon_ncost os) as NN.
  unfold hcb_e in Hp. apply andb_true_iff in Hp as [_ Hp].
  apply existsb_exists in Hp as [k [Hk Hok]].
  apply in_map_iff in Hk as [w [<- Hw]].
  rewrite filter_map_len in Hok.
  set (Gs := filter (fun w' => col_eqb (keyS t w) (keyS t w')) strict) in Hok.
  assert (HG : length Gs <= 2 ^ ncmpS os).
  { apply (class_boundS t os Gs V D).
    - apply NoDup_filter; auto.
    - intros x Hx. apply filter_In in Hx. tauto.
    - intros w1 w2 H1 H2'. apply filter_In in H1 as [_ H1]. apply filter_In in H2' as [_ H2'].
      apply col_eqb_spec in H1, H2'. apply key_ksimS. congruence. }
  rewrite forallb_forall in Hok. specialize (Hok (ncmpS os) ltac:(apply in_seq; lia)).
  apply orb_true_iff in Hok as [Hok|Hok]; apply Nat.ltb_lt in Hok; lia.
Qed.

Theorem pruneS_sound t b : smarked t -> pruneS t b = true -> ~ sgood t b.
Proof.
  intros Hm Hp G. destruct (sgood_ops t b G) as [os0 [V0 [Cs0 D0]]].
  destruct (red_ok os0 t Hm V0 D0) as [V [D Cr]]. set (os := red t os0) in *.
  pose proof (undone_ops t os Hm D) as U. pose proof (costs_split os) as Cs.
  pose proof (red_cmp_le os0 t) as H2. fold os in H2. pose proof (nnon_ncost os) as NN.
  pose proof (undone_nnon t os Hm D) as UN.
  unfold pruneS in Hp. apply orb_true_iff in Hp as [Hp|Hp]; [apply orb_true_iff in Hp as [Hp|Hp]|].
  - apply Nat.ltb_lt in Hp. lia.
  - unfold deadSb in Hp. apply existsb_exists in Hp as [w [Hw Hp]]. apply in_seq in Hw.
    apply existsb_exists in Hp as [j [Hj Hp]]. apply in_seq in Hj.
    apply andb_true_iff in Hp as [Hu Hp]. apply negb_true_iff in Hu. rewrite tgp_spec in Hp by lia.
    apply (dead_sound t b G w j); [lia|lia|auto|].
    intros a Ha E. rewrite forallb_forall in Hp. specialize (Hp a Ha). rewrite E, Nat.eqb_refl in Hp. discriminate.
  - unfold hcbS in Hp. apply orb_true_iff in Hp as [Hp|Hp].
    + apply (hcb_e_sound t b 0 os V D ltac:(lia) H2 ltac:(lia) UN Hp).
    + apply (hcb_e_sound t b _ os V D ltac:(lia) H2 (h3_bound t os _ Hm V D) UN Hp).
Qed.


(* ---------- checker ---------- *)
Variable feqb : F -> F -> bool.
Hypothesis feqb_spec : forall f g, feqb f g = true -> f = g.
Variable cmpC : C -> C -> bool.        (* any order, used to sort A; no spec needed *)
Variable firstnep : F -> comparison.   (* = firstne (decf f), only a choice of polarity; no spec needed *)
Variable hashS : sst -> positive.      (* untrusted *)

Fixpoint insC (x : C) (l : list C) : list C :=
  match l with [] => [x] | y :: l' => if cmpC x y then x :: l else y :: insC x l' end.
Fixpoint sortC (l : list C) : list C := match l with [] => [] | x :: l' => insC x (sortC l') end.

Lemma perm_insC x l : Permutation (x :: l) (insC x l).
Proof.
  induction l as [|y l IH]; simpl; auto. destruct (cmpC x y); auto.
  eapply perm_trans; [apply perm_swap|]. apply perm_skip, IH.
Qed.

Lemma perm_sortC l : Permutation l (sortC l).
Proof. induction l as [|x l IH]; simpl; auto. eapply perm_trans; [apply perm_skip, IH|apply perm_insC]. Qed.

Definition canon1 (t : sst) : sst :=
  let t1 := SS (sortC (sA t)) (sf t) (sdn t) in
  match firstnep (sf t) with Gt => negS t1 | _ => t1 end.

Lemma canon1_good t b : sgood t b -> sgood (canon1 t) b.
Proof.
  intros G.
  assert (G1 : sgood (SS (sortC (sA t)) (sf t) (sdn t)) b).
  { apply (sgood_seq t); auto. split; [|split; reflexivity]. intros x. simpl.
    split; intros H; [eapply Permutation_in; [apply perm_sortC|exact H]|
                      eapply Permutation_in; [apply Permutation_sym, perm_sortC|exact H]]. }
  unfold canon1. destruct (firstnep (sf t)); auto. apply sgood_neg, G1.
Qed.

Lemma canon1_marked t : smarked t -> smarked (canon1 t).
Proof.
  intros M j Hj Hm.
  assert (K : memb (nth j tgp Tp) (sortC (sA t)) = true -> nth j (sdn t) false = true).
  { intros Q. apply M; auto. apply memb_spec. apply memb_spec in Q.
    eapply Permutation_in; [apply Permutation_sym, perm_sortC|exact Q]. }
  unfold canon1 in *. destruct (firstnep (sf t)); simpl in *; apply K; exact Hm.
Qed.


(* ---------- Rule G: row permutations (input relabelling S_n) ---------- *)
Definition rp (pi : list nat) (l : col) : col := map (fun w => nth (nth w pi 0) l 0) (seq 0 W).
Definition rpf (pi : list nat) (l : list comparison) : list comparison := map (fun w => nth (nth w pi 0) l Eq) (seq 0 W).
Definition pi_ok (pi : list nat) : Prop :=
  (forall w, w < W -> nth w pi 0 < W) /\ (forall v, v < W -> exists w, w < W /\ nth w pi 0 = v).

Variable perms : list (list nat).
Variable permc : list nat -> C -> C.
Hypothesis permc_spec : forall pi, In pi perms -> forall a, dec (permc pi a) = rp pi (dec a).
Variable permf : list nat -> F -> F.
Hypothesis permf_spec : forall pi, In pi perms -> forall f, decf (permf pi f) = rpf pi (decf f).
Hypothesis perms_ok : forall pi, In pi perms -> pi_ok pi /\ (forall j, j < n -> rp pi (tgt reps j) = tgt reps j).

Lemma rp_len pi l : length (rp pi l) = W.
Proof. unfold rp. now rewrite length_map, length_seq. Qed.

Lemma nth_rp pi l w : w < W -> nth w (rp pi l) 0 = nth (nth w pi 0) l 0.
Proof. intros Hw. unfold rp. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto). now rewrite seq_nth. Qed.

Lemma nth_rpf pi l w : w < W -> nth w (rpf pi l) Eq = nth (nth w pi 0) l Eq.
Proof. intros Hw. unfold rpf. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto). now rewrite seq_nth. Qed.

Lemma rpf_len pi l : length (rpf pi l) = W.
Proof. unfold rpf. now rewrite length_map, length_seq. Qed.

Lemma rp_blend pi c f d x : pi_ok pi -> length f = W -> length d = W -> length x = W ->
  rp pi (blend c f d x) = blend c (rpf pi f) (rp pi d) (rp pi x).
Proof.
  intros [P1 _] Lf Ld Lx. apply nth_ext with (d := 0) (d' := 0).
  - rewrite rp_len. symmetry. apply blend_len; [apply rpf_len|apply rp_len|apply rp_len].
  - intros w Hw. rewrite rp_len in Hw. rewrite nth_rp by auto.
    rewrite !blend_nth; rewrite ?rpf_len, ?rp_len, ?Lf, ?Ld, ?Lx; auto.
    rewrite nth_rpf, !nth_rp by auto. reflexivity.
Qed.

Lemma rp_cmpcol pi a b : pi_ok pi -> length a = W -> length b = W ->
  rpf pi (cmpcol a b) = cmpcol (rp pi a) (rp pi b).
Proof.
  intros [P1 _] La Lb. apply nth_ext with (d := Eq) (d' := Eq).
  - rewrite rpf_len. symmetry. apply cmpcol_len; apply rp_len.
  - intros w Hw. rewrite rpf_len in Hw. rewrite nth_rpf by auto.
    rewrite !cmpcol_nth; rewrite ?rp_len, ?La, ?Lb; auto. rewrite !nth_rp by auto. reflexivity.
Qed.

Lemma rp_inj pi a b : pi_ok pi -> length a = W -> length b = W -> rp pi a = rp pi b -> a = b.
Proof.
  intros [_ P2] La Lb E. apply nth_ext with (d := 0) (d' := 0); [congruence|].
  intros v Hv. rewrite La in Hv. destruct (P2 v Hv) as [w [Hw <-]].
  rewrite <- !nth_rp by auto. now rewrite E.
Qed.

Lemma rpf_inj pi a b : pi_ok pi -> length a = W -> length b = W -> rpf pi a = rpf pi b -> a = b.
Proof.
  intros [_ P2] La Lb E. apply nth_ext with (d := Eq) (d' := Eq); [congruence|].
  intros v Hv. rewrite La in Hv. destruct (P2 v Hv) as [w [Hw <-]].
  rewrite <- !nth_rpf by auto. now rewrite E.
Qed.

Section Perm.
Variable pi : list nat.
Hypothesis Hpi : In pi perms.

Lemma permc_inj a b : permc pi a = permc pi b -> a = b.
Proof.
  intros E. apply dec_inj. apply (rp_inj pi); try apply dec_len; [apply perms_ok, Hpi|].
  rewrite <- !(permc_spec pi Hpi). now rewrite E.
Qed.

Lemma permc_T : permc pi Tp = Tp.
Proof.
  apply dec_inj. rewrite (permc_spec pi Hpi), Tp_spec. apply nth_ext with (d := 0) (d' := 0).
  - rewrite rp_len, repeat_length. reflexivity.
  - intros w Hw. rewrite rp_len in Hw. rewrite nth_rp by auto.
    destruct (perms_ok pi Hpi) as [[P1 _] _]. rewrite !nth_repeat_lt; auto.
Qed.

Lemma permc_tgt j : j < n -> permc pi (nth j tgp Tp) = nth j tgp Tp.
Proof. intros Hj. apply dec_inj. rewrite (permc_spec pi Hpi), tgp_spec by auto. apply perms_ok; auto. Qed.

Lemma memb_perm x l : memb (permc pi x) (map (permc pi) l) = memb x l.
Proof.
  induction l as [|y l IH]; simpl; auto. unfold memb in *. simpl. rewrite IH. f_equal.
  destruct (ceqb x y) eqn:E, (ceqb (permc pi x) (permc pi y)) eqn:E'; auto.
  - apply ceqb_spec in E. subst. rewrite ceqb_refl in E'. discriminate.
  - apply ceqb_spec, permc_inj in E'. subst. rewrite ceqb_refl in E. discriminate.
Qed.

Lemma ceqb_perm_T x : ceqb (permc pi x) Tp = ceqb x Tp.
Proof.
  destruct (ceqb x Tp) eqn:E, (ceqb (permc pi x) Tp) eqn:E'; auto.
  - apply ceqb_spec in E. subst. rewrite permc_T, ceqb_refl in E'. discriminate.
  - apply ceqb_spec in E'. rewrite <- permc_T in E'. apply permc_inj in E'. subst. rewrite ceqb_refl in E. discriminate.
Qed.

Lemma map_remc x l : map (permc pi) (remc x l) = remc (permc pi x) (map (permc pi) l).
Proof.
  induction l as [|y l IH]; simpl; auto. unfold remc in *. simpl.
  destruct (ceqb x y) eqn:E, (ceqb (permc pi x) (permc pi y)) eqn:E'; simpl; rewrite ?IH; auto.
  - apply ceqb_spec in E. subst. rewrite ceqb_refl in E'. discriminate.
  - apply ceqb_spec, permc_inj in E'. subst. rewrite ceqb_refl in E. discriminate.
Qed.

Lemma map_addc x l : map (permc pi) (addc x l) = addc (permc pi x) (map (permc pi) l).
Proof. unfold addc. rewrite ceqb_perm_T, memb_perm. destruct (ceqb x Tp), (memb x l); reflexivity. Qed.

Definition permS (t : sst) : sst := SS (map (permc pi) (sA t)) (permf pi (sf t)) (sdn t).
Definition permop (o : sop) : sop :=
  match o with
  | SCmp a b => SCmp (permc pi a) (permc pi b)
  | SIn c d x => SIn c (permc pi d) (permc pi x)
  | SCopy c d x => SCopy c (permc pi d) (permc pi x)
  end.

Lemma blendp_perm c f d x : blendp c (permf pi f) (permc pi d) (permc pi x) = permc pi (blendp c f d x).
Proof.
  apply dec_inj. rewrite blendp_spec, !(permc_spec pi Hpi), (permf_spec pi Hpi), blendp_spec.
  symmetry. apply rp_blend; [apply perms_ok, Hpi|apply decf_len|apply dec_len|apply dec_len].
Qed.

Lemma cmpp_perm a b : cmpp (permc pi a) (permc pi b) = permf pi (cmpp a b).
Proof.
  apply decf_inj. rewrite cmpp_spec, !(permc_spec pi Hpi), (permf_spec pi Hpi), cmpp_spec.
  symmetry. apply rp_cmpcol; [apply perms_ok, Hpi|apply dec_len|apply dec_len].
Qed.

Lemma smark_perm t : smark (permS t) = permS (smark t).
Proof.
  unfold smark, permS; simpl. f_equal. apply map_ext_in. intros j Hj. apply in_seq in Hj.
  rewrite <- (permc_tgt j) at 1 by lia. now rewrite memb_perm.
Qed.

Lemma sstep_perm t o : sstep (permS t) (permop o) = permS (sstep t o).
Proof.
  unfold sstep. rewrite <- smark_perm. f_equal.
  destruct o as [a b|c d x|c d x]; unfold permS; simpl.
  - now rewrite cmpp_perm.
  - now rewrite blendp_perm, map_addc, map_remc.
  - now rewrite blendp_perm, map_addc.
Qed.

Lemma sgood_perm t b : sgood t b -> sgood (permS t) b.
Proof.
  induction 1 as [t b D|t b o V G IH].
  - apply sg_done. exact D.
  - replace (cost o) with (cost (permop o)) by (destruct o; reflexivity).
    apply sg_step; [|rewrite sstep_perm; exact IH].
    assert (Hx : forall x, opnd t x -> opnd (permS t) (permc pi x)).
    { intros x [->|Hx]; [left; apply permc_T|right; unfold permS; simpl; apply in_map, Hx]. }
    destruct o; simpl in *; intuition.
Qed.

Lemma perm_marked t : smarked t -> smarked (permS t).
Proof.
  intros M j Hj Hm. unfold permS in *; simpl in *. rewrite <- (permc_tgt j) in Hm by auto.
  rewrite memb_perm in Hm. apply M; auto.
Qed.
End Perm.

Variable ltS : sst -> sst -> bool.   (* any order on states, used to pick a representative; no spec *)

Definition canonS (t : sst) : sst :=
  fold_left (fun best pi => let c := canon1 (permS pi t) in if ltS c best then c else best) perms (canon1 t).

Lemma canonS_good t b : sgood t b -> sgood (canonS t) b.
Proof.
  intros G. unfold canonS.
  assert (H : forall l best, incl l perms -> sgood best b ->
            sgood (fold_left (fun best pi => let c := canon1 (permS pi t) in if ltS c best then c else best) l best) b).
  { induction l as [|pi l IH]; simpl; intros best Hl Gb; auto.
    apply IH; [intros x Hx; apply Hl; now right|].
    destruct (ltS _ _); auto. apply canon1_good, sgood_perm; auto. apply Hl; now left. }
  apply H; [intros x Hx; exact Hx|]. apply canon1_good, G.
Qed.

Lemma canonS_marked t : smarked t -> smarked (canonS t).
Proof.
  intros M. unfold canonS.
  assert (H : forall l best, incl l perms -> smarked best ->
            smarked (fold_left (fun best pi => let c := canon1 (permS pi t) in if ltS c best then c else best) l best)).
  { induction l as [|pi l IH]; simpl; intros best Hl Mb; auto.
    apply IH; [intros x Hx; apply Hl; now right|].
    destruct (ltS _ _); auto. apply canon1_marked, perm_marked; auto. apply Hl; now left. }
  apply H; [intros x Hx; exact Hx|]. apply canon1_marked, M.
Qed.

Definition condsS : list cond := filter iset [CL; CG; CLE; CGE].

Definition opsS (t : sst) : list sop :=
  let xs := Tp :: sA t in
  flat_map (fun a => flat_map (fun b => SCmp a b :: flat_map (fun c => [SIn c a b; SCopy c a b]) condsS) xs) xs.

Lemma opsS_in t a b : In a (Tp :: sA t) -> In b (Tp :: sA t) ->
  In (SCmp a b) (opsS t) /\ forall c, iset c = true -> In (SIn c a b) (opsS t) /\ In (SCopy c a b) (opsS t).
Proof.
  intros Ha Hb. unfold opsS.
  assert (G : forall o, In o (SCmp a b :: flat_map (fun c => [SIn c a b; SCopy c a b]) condsS) -> In o (opsS t)).
  { intros o Ho. unfold opsS. apply in_flat_map. exists a. split; auto. apply in_flat_map. exists b. split; auto. }
  split; [apply G; now left|]. intros c Hc.
  assert (Hcc : In c condsS) by (unfold condsS; apply filter_In; split; auto; destruct c; simpl; auto).
  split; apply G; right; apply in_flat_map; exists c; split; simpl; auto.
Qed.

Lemma opsS_complete t o : valid t o -> In o (opsS t).
Proof.
  intros V.
  assert (Hx : forall x, opnd t x -> In x (Tp :: sA t)) by (intros x [->|H]; [now left|now right]).
  destruct o as [a b|c d x|c d x]; simpl in V.
  - destruct V as [Oa Ob]. apply (opsS_in t a b (Hx a Oa) (Hx b Ob)).
  - destruct V as [Hc [Od Ox]]. apply (proj2 (opsS_in t d x (Hx d Od) (Hx x Ox)) c Hc).
  - destruct V as [Hc [Od Ox]]. apply (proj2 (opsS_in t d x (Hx d Od) (Hx x Ox)) c Hc).
Qed.

Fixpoint lsteqb {A} (e : A -> A -> bool) (a b : list A) : bool :=
  match a, b with [], [] => true | x :: a', y :: b' => e x y && lsteqb e a' b' | _, _ => false end.

Lemma lsteqb_true {A} (e : A -> A -> bool) a b : (forall x y, e x y = true -> x = y) -> lsteqb e a b = true -> a = b.
Proof.
  intros He. revert b; induction a; intros [|]; simpl; intros H; try discriminate; auto.
  apply andb_true_iff in H as [H1 H2]. f_equal; auto.
Qed.

Definition sst_eqb (t u : sst) : bool :=
  lsteqb ceqb (sA t) (sA u) && feqb (sf t) (sf u) && lsteqb Bool.eqb (sdn t) (sdn u).

Lemma sst_eqb_true t u : sst_eqb t u = true -> t = u.
Proof.
  unfold sst_eqb. intros H. apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  apply lsteqb_true in H1; [|intros; apply ceqb_spec; auto].
  apply feqb_spec in H2. apply lsteqb_true in H3; [|intros x y E; apply Bool.eqb_prop, E].
  destruct t, u; simpl in *; congruence.
Qed.

Definition sbucket := list (sst * nat).
Definition stbl := FMapPositive.PositiveMap.t sbucket.

Fixpoint sblook (t : sst) (bk : sbucket) : option nat :=
  match bk with [] => None | (u, b) :: bk' => if sst_eqb u t then Some b else sblook t bk' end.

Definition stlook (m : stbl) (t : sst) : option nat :=
  match FMapPositive.PositiveMap.find (hashS t) m with None => None | Some bk => sblook t bk end.

Definition stadd (m : stbl) (t : sst) (b : nat) : stbl :=
  FMapPositive.PositiveMap.add (hashS t)
    ((t, b) :: match FMapPositive.PositiveMap.find (hashS t) m with Some bk => bk | None => [] end) m.

Definition sbuild (V : list (sst * nat)) : stbl :=
  fold_left (fun m e => stadd m (fst e) (snd e)) V (FMapPositive.PositiveMap.empty _).

Lemma sblook_in t bk b : sblook t bk = Some b -> In (t, b) bk.
Proof.
  induction bk as [|[u b'] bk IH]; simpl; [discriminate|].
  destruct (sst_eqb u t) eqn:E; intros H; [left|right; auto].
  apply sst_eqb_true in E. inversion H. now subst.
Qed.

Lemma sbuild_inv (P : sst * nat -> Prop) V m :
  (forall k bk e, FMapPositive.PositiveMap.find k m = Some bk -> In e bk -> P e) -> (forall e, In e V -> P e) ->
  forall k bk e, FMapPositive.PositiveMap.find k (fold_left (fun m e => stadd m (fst e) (snd e)) V m) = Some bk ->
  In e bk -> P e.
Proof.
  revert m; induction V as [|[u b] V IH]; simpl; intros m Hm HV; auto.
  apply IH; [|intros; apply HV; now right]. intros k bk e Hf He. unfold stadd in Hf.
  destruct (BinPos.Pos.eq_dec k (hashS u)) as [->|Hk].
  - rewrite FMapPositive.PositiveMap.gss in Hf. inversion Hf; subst. destruct He as [<-|He]; [apply HV; now left|].
    assert (Q : forall (o : option sbucket), In e (match o with Some bk => bk | None => [] end) ->
                exists bk, o = Some bk /\ In e bk) by (intros [] H; simpl in H; [eauto|destruct H]).
    destruct (Q _ He) as [bk0 [F0 He']]. eapply Hm; eauto.
  - rewrite FMapPositive.PositiveMap.gso in Hf by auto. eapply Hm; eauto.
Qed.

Lemma stlook_build V t b : stlook (sbuild V) t = Some b -> In (t, b) V.
Proof.
  unfold stlook. destruct (FMapPositive.PositiveMap.find (hashS t) (sbuild V)) as [bk|] eqn:Fd; [|discriminate].
  intros H. apply sblook_in in H.
  apply (sbuild_inv (fun e => In e V) V (FMapPositive.PositiveMap.empty _)) with (k := hashS t) (bk := bk); auto.
  intros k bk' e Hf. rewrite FMapPositive.PositiveMap.gempty in Hf. discriminate.
Qed.


(* ---------- Lemma M (dominance) and rule E3 ---------- *)
Definition dom (u t : sst) : Prop :=
  (forall x, In x (sA u) -> In x (sA t)) /\ sf u = sf t /\
  (forall j, j < n -> nth j (sdn u) false = true -> nth j (sdn t) false = true).

Lemma in_addc' x y l : In y (addc x l) -> In y l \/ (y = x /\ x <> Tp).
Proof.
  unfold addc. destruct (ceqb x Tp) eqn:E; [auto|]. destruct (memb x l); [auto|].
  intros [<-|H]; [right; split; auto; intros Q; apply ceqb_spec in Q; congruence|auto].
Qed.

Lemma addc_mono x l l' : (forall y, In y l -> In y l') -> forall y, In y (addc x l) -> In y (addc x l').
Proof.
  intros H y Hy. apply in_addc' in Hy as [Hy|[-> Hx]]; [apply addc_sub, H, Hy|apply addc_in, Hx].
Qed.

Lemma dom_step u t o : dom u t -> dom (sstep u o) (sstep t o).
Proof.
  intros [D1 [D2 D3]].
  assert (A : forall x, In x (sA (sstep u o)) -> In x (sA (sstep t o))).
  { intros x Hx. unfold sstep, smark in *; simpl in *. rewrite D2 in Hx.
    destruct o as [a b|c d y|c d y]; simpl in *; auto.
    - revert x Hx. apply addc_mono. intros z Hz. apply in_remc in Hz as [Hz Hne]. apply in_remc. auto.
    - revert x Hx. apply addc_mono. exact D1. }
  split; [exact A|]. split.
  - unfold sstep, smark; destruct o; simpl; congruence.
  - intros j Hj Q. rewrite sstep_dn in Q |- * by auto.
    destruct (nth j (sdn u) false) eqn:E; [rewrite (D3 j Hj E); auto|].
    destruct (nth j (sdn t) false); auto. apply memb_spec. apply memb_spec in Q. auto.
Qed.

Lemma valid_dom u t o : dom u t -> valid u o -> valid t o.
Proof.
  intros [D1 _] V. unfold opnd in *.
  assert (K : forall x, x = Tp \/ In x (sA u) -> x = Tp \/ In x (sA t)) by (intros x [E|E]; [now left|right; auto]).
  destruct o; simpl in *; [destruct V as [V1 V2]; split; apply K; auto|
    destruct V as [V0 [V1 V2]]; split; [auto|split; apply K; auto]..].
Qed.

Lemma lemma_M u t b : sgood u b -> dom u t -> sgood t b.
Proof.
  intros G. revert t. induction G as [u b D|u b o V G IH]; intros t HD.
  - apply sg_done. intros j Hj. apply HD; auto.
  - apply sg_step; [eapply valid_dom; eauto|]. apply IH, dom_step, HD.
Qed.

Definition domb (u t : sst) : bool :=
  forallb (fun x => memb x (sA t)) (sA u) && feqb (sf u) (sf t) &&
  forallb (fun j => implb (nth j (sdn u) false) (nth j (sdn t) false)) (seq 0 n).

Lemma domb_spec u t : domb u t = true -> dom u t.
Proof.
  unfold domb. intros H. apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  rewrite forallb_forall in H1, H3. split; [intros x Hx; apply memb_spec, H1, Hx|]. split; [apply feqb_spec, H2|].
  intros j Hj Q. specialize (H3 j ltac:(apply in_seq; lia)). rewrite Q in H3. exact H3.
Qed.

Definition smarkedb (t : sst) : bool :=
  forallb (fun j => implb (memb (nth j tgp Tp) (sA t)) (nth j (sdn t) false)) (seq 0 n).
Definition sdoneb (t : sst) : bool := forallb (fun j => nth j (sdn t) false) (seq 0 n).

Lemma smarkedb_spec t : smarkedb t = true -> smarked t.
Proof.
  unfold smarkedb. rewrite forallb_forall. intros H j Hj Hm.
  specialize (H j ltac:(apply in_seq; lia)). rewrite Hm in H. exact H.
Qed.

Lemma sdoneb_spec t : sdone t -> sdoneb t = true.
Proof. intros D. unfold sdoneb. apply forallb_forall. intros j Hj. apply in_seq in Hj. apply D. lia. Qed.

Definition scovered (m : stbl) (t : sst) (b : nat) : bool :=
  match stlook m t with Some b' => Nat.leb b b' | None => false end || pruneS t b.

Definition scheck_entry (m : stbl) (e : sst * nat) : bool :=
  let (t, b) := e in
  smarkedb t && negb (sdoneb t) &&
  forallb (fun o => if Nat.leb (cost o) b then
                      domb (sstep t o) t || scovered m (canonS (sstep t o)) (b - cost o) else true) (opsS t).

Definition scheck (V : list (sst * nat)) : bool := let m := sbuild V in forallb (scheck_entry m) V.

Theorem scheck_sound V : scheck V = true -> forall b t b', In (t, b') V -> b <= b' -> ~ sgood t b.
Proof.
  unfold scheck. intros HC. rewrite forallb_forall in HC.
  induction b as [b IH] using (well_founded_induction lt_wf). intros t b' Hin Hle G.
  pose proof (HC _ Hin) as HE. unfold scheck_entry in HE.
  apply andb_true_iff in HE as [HE HS]. apply andb_true_iff in HE as [HM HD].
  apply smarkedb_spec in HM. apply negb_true_iff in HD.
  destruct G as [t b D|t b0 o Vo G].
  - rewrite sdoneb_spec in HD by auto. discriminate.
  - rewrite forallb_forall in HS. specialize (HS o (opsS_complete t o Vo)).
    assert (Hc : cost o <= b') by lia. apply Nat.leb_le in Hc. rewrite Hc in HS. apply Nat.leb_le in Hc.
    apply orb_true_iff in HS as [HS|HS].
    { apply domb_spec in HS. apply (IH b0 ltac:(destruct o; simpl; lia) t b' Hin ltac:(lia)).
      apply (lemma_M (sstep t o)); auto. }
    set (u := canonS (sstep t o)) in HS.
    assert (Gu : sgood u b0) by (apply canonS_good, G).
    unfold scovered in HS. apply orb_true_iff in HS as [HS|HS].
    + destruct (stlook (sbuild V) u) as [b3|] eqn:Fd; [|discriminate].
      apply Nat.leb_le in HS. apply stlook_build in Fd.
      apply (IH b0 ltac:(destruct o; simpl; lia) u b3 Fd ltac:(lia) Gu).
    + apply (pruneS_sound u (b' - cost o)); [apply canonS_marked, sstep_marked|exact HS|].
      apply sgood_mono with b0; [exact Gu|lia].
Qed.

(* ---------- root and the end theorem ---------- *)
Variable encp : col -> C.
Hypothesis encp_spec : forall l, length l = W -> (forall v, In v l -> v <= n) -> dec (encp l) = l.
Variable encf : list comparison -> F.
Hypothesis encf_spec : forall l, length l = W -> decf (encf l) = l.
Hypothesis Hn1 : 1 <= n.
Hypothesis HnR : n <= R.

Definition incol (r : nat) : col := map (fun rep => nth r rep 0) reps.
Definition inputsC : list C := map (fun r => encp (incol r)) (seq 0 n).
Definition root0 : sst := smark (SS inputsC (encf (repeat Eq W)) (repeat false n)).
Definition rootS : sst := canonS root0.

Lemma incol_vals r v : r < n -> In v (incol r) -> v < n.
Proof.
  unfold incol. intros Hr Hv. apply in_map_iff in Hv as [rep [<- Hrep]].
  apply Hreps in Hrep as [L Hv]. apply Hv, nth_In. lia.
Qed.

Lemma getc_vinit r : r < R -> getc (vinit n R reps) r = if Nat.ltb r n then incol r else Tl.
Proof.
  intros Hr. unfold getc, vinit. simpl. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
  rewrite seq_nth by auto. reflexivity.
Qed.

Lemma incol_nonT r : r < n -> nonT (incol r) = true.
Proof.
  intros Hr. unfold nonT. apply negb_true_iff. destruct (col_eqb _ _) eqn:E; auto. exfalso.
  apply col_eqb_spec in E.
  assert (L : length (incol r) = W) by (unfold incol; rewrite length_map; reflexivity).
  assert (I : In (nth 0 (incol r) 0) (incol r)) by (apply nth_In; lia).
  assert (N0 : nth 0 (incol r) 0 = n) by (rewrite E; unfold Tl; apply nth_repeat_lt; lia).
  rewrite N0 in I. apply (incol_vals r n) in I; auto. lia.
Qed.

Definition inputs_distinct : bool :=
  forallb (fun r1 => forallb (fun r2 => implb (col_eqb (incol r1) (incol r2)) (Nat.eqb r1 r2)) (seq 0 n)) (seq 0 n).

Lemma filter_map_comm {A B} (f : B -> bool) (g : A -> B) l : filter f (map g l) = map g (filter (fun x => f (g x)) l).
Proof. induction l as [|a l IH]; simpl; auto. destruct (f (g a)); simpl; rewrite IH; auto. Qed.

Lemma filter_lt_seq : filter (fun r => Nat.ltb r n) (seq 0 R) = seq 0 n.
Proof.
  replace R with (n + (R - n)) by lia. rewrite seq_app, filter_app.
  rewrite (filter_ext_in _ (fun _ => true) (seq 0 n)) by (intros r Hr; apply in_seq in Hr; apply Nat.ltb_lt; lia).
  rewrite (filter_ext_in _ (fun _ => false) (seq (0 + n) (R - n))) by (intros r Hr; apply in_seq in Hr; apply Nat.ltb_ge; lia).
  rewrite filter_true. assert (Z : forall l : list nat, filter (fun _ => false) l = []) by (induction l; auto).
  rewrite Z, app_nil_r. reflexivity.
Qed.

Lemma Phi_vinit : inputs_distinct = true -> Phi (vinit n R reps) = 0.
Proof.
  intros HD. unfold Phi.
  assert (E : Lreg (vinit n R reps) = map incol (seq 0 n)).
  { unfold Lreg. rewrite filter_map_comm.
    rewrite (filter_ext_in _ (fun r => Nat.ltb r n)).
    - rewrite filter_lt_seq. apply map_ext_in. intros r Hr. apply in_seq in Hr. rewrite getc_vinit by lia.
      destruct (Nat.ltb_spec r n); [reflexivity|lia].
    - intros r Hr. apply in_seq in Hr. rewrite getc_vinit by lia. destruct (Nat.ltb_spec r n).
      + apply incol_nonT; auto.
      + unfold nonT. apply negb_false_iff, col_eqb_spec. reflexivity. }
  rewrite E. unfold ndl. rewrite nodup_fixed_point; [lia|].
  apply NoDup_map_inj; [apply seq_NoDup|]. intros r1 r2 H1 H2 Q.
  unfold inputs_distinct in HD. rewrite forallb_forall in HD. specialize (HD r1 H1).
  rewrite forallb_forall in HD. specialize (HD r2 H2). rewrite Q in HD.
  assert (col_eqb (incol r2) (incol r2) = true) by (apply col_eqb_spec; auto). rewrite H in HD.
  apply Nat.eqb_eq, HD.
Qed.

Lemma Inv_root : Inv (vinit n R reps) root0.
Proof.
  split; [|split; [|split]].
  - intros r Hr Hn. rewrite getc_vinit in * by auto. destruct (Nat.ltb_spec r n).
    + exists (encp (incol r)). split.
      * unfold root0, smark, inputsC; simpl. apply in_map_iff. exists r. split; auto. apply in_seq. lia.
      * apply encp_spec; [unfold incol; rewrite length_map; reflexivity|].
        intros v Hv. apply (incol_vals r v) in Hv; lia.
    + unfold nonT in Hn. assert (col_eqb Tl Tl = true) by (apply col_eqb_spec; auto). rewrite H0 in Hn. discriminate.
  - unfold root0, smark; simpl. rewrite encf_spec by (apply repeat_length). reflexivity.
  - intros a Ha E. unfold root0, smark, inputsC in Ha; simpl in Ha. apply in_map_iff in Ha as [r [<- Hr]].
    apply in_seq in Hr.
    assert (D : dec (encp (incol r)) = incol r).
    { apply encp_spec; [unfold incol; rewrite length_map; reflexivity|].
      intros v Hv. apply (incol_vals r v) in Hv; lia. }
    rewrite E, Tp_spec in D. fold Tl in D. pose proof (incol_nonT r ltac:(lia)) as N. rewrite <- D in N.
    unfold nonT in N. assert (col_eqb Tl Tl = true) by (apply col_eqb_spec; auto). rewrite H in N.
    discriminate.
  - intros j Hj Q. apply smark_marked; auto.
Qed.

Definition scertifies (V : list (sst * nat)) (k : nat) : bool :=
  inputs_distinct && scheck V && match stlook (sbuild V) rootS with Some b => Nat.leb k b | None => false end.

Theorem scertifies_sound V k : scertifies V k = true ->
  forall p o, length p <= k -> prog_ok iset R p -> ~ RelaxedSnap n p o.
Proof.
  unfold scertifies. intros H p o Hl Hok Hc.
  apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  destruct (stlook (sbuild V) rootS) as [b|] eqn:Fd; [|discriminate].
  apply Nat.leb_le in H3. apply stlook_build in Fd.
  assert (Hp : forall i, In i p -> instr_wf R i) by (intros; apply Hok; auto).
  assert (Ach : forall j, j < n -> nth j (sdn root0) false = true \/ achieved R reps p (vinit n R reps) j).
  { intros j Hj. right.
    pose proof (snap_reg_lt n R p o Hn1 HnR Hc Hp j Hj) as Hr.
    pose proof (relaxed_snap_cols n R reps p o HnR Hreps Hc Hp j Hj Hr) as E.
    destruct (Nat.le_gt_cases (snd (o j)) (length p)) as [Hle|Hgt].
    - exists (snd (o j)). split; auto. exists (fst (o j)). split; auto.
    - exists (length p). split; auto. exists (fst (o j)). split; auto.
      rewrite firstn_all. rewrite firstn_all2 in E by lia. exact E. }
  pose proof (lemma_S p (vinit n R reps) root0 (vwf_init n R reps) Hok Inv_root Ach) as G.
  rewrite Phi_vinit in G by auto. rewrite Nat.add_0_r in G.
  apply (scheck_sound V H2 k rootS b Fd H3). apply canonS_good. apply sgood_mono with (length p); auto.
Qed.

End SetModel.
