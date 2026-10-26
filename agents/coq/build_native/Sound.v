(* Sound.v -- soundness of the certificate checker of Check.v (M_out, snapshot outputs).
   Main theorem certifies_sound: if certifies V k = true then no program of length <= k
   (instructions in iset, registers < R) is RelaxedSnap-correct for n inputs. *)
From Stdlib Require Import List Bool Lia Arith ZArith PArith FMapPositive Mergesort.
From CmovSort Require Import Machine Vec Good Prune Check.
Import ListNotations.

Section Sound.
Variables (n R : nat) (reps : list (list nat)) (tg : list col) (strict : list nat) (iset : cond -> bool).
Let W := length reps.
Hypothesis Hn1 : 1 <= n.
Hypothesis HnR : n <= R.
Hypothesis Hreps : reps_ok n reps.
Hypothesis Htg : forall j, j < n -> nth j tg [] = tgt reps j.
Hypothesis Htd : forall j1 j2, j1 < n -> j2 < n -> tgt reps j1 = tgt reps j2 -> j1 = j2.
Hypothesis Hstrict : forall w, In w strict ->
  w < W /\ NoDup (nth w reps []) /\ NatSort.sort (nth w reps []) = seq 0 n.
Hypothesis Hsdist : forall w1 w2, In w1 strict -> In w2 strict -> nth w1 reps [] = nth w2 reps [] -> w1 = w2.
Hypothesis HsND : NoDup strict.
Hypothesis Hsym : forall c, iset (swapc c) = iset c.

Local Notation vgood := (vgood n R reps iset).
Local Notation has := (has R reps).

Lemma hasb_spec s j : length (cols s) = R -> j < n -> hasb tg s j = true <-> has s j.
Proof.
  intros L Hj. unfold hasb, Good.has. rewrite existsb_exists. split.
  - intros [c [Hc E]]. apply col_eqb_spec in E. apply In_nth with (d := []) in Hc as [r [Hr Er]].
    exists r. split; [unfold col in *; lia|]. unfold getc. transitivity c; [exact Er|]. rewrite E, Htg; auto.
  - intros [r [Hr E]]. exists (getc s r). split; [unfold getc; apply nth_In; unfold col in *; lia|].
    apply col_eqb_spec. rewrite E, Htg; auto.
Qed.

Lemma markb_dn s j : j < n -> nth j (dn (markb n tg s)) false = nth j (dn s) false || hasb tg s j.
Proof.
  intros Hj. unfold markb; simpl. rewrite (nth_map_lt _ _ _ _ 0) by (rewrite length_seq; auto).
  rewrite seq_nth by auto. reflexivity.
Qed.

Lemma markb_marked s : length (cols s) = R -> marked n R reps (markb n tg s).
Proof.
  intros L j Hj Hh. unfold isdone. rewrite markb_dn by auto.
  assert (hasb tg s j = true).
  { apply hasb_spec; auto. }
  rewrite H. apply orb_true_r.
Qed.

Lemma markb_good s b : vgood s b -> vgood (markb n tg s) b.
Proof.
  apply vgood_more_done; auto. intros j Hj D. unfold isdone in *. rewrite markb_dn by auto.
  rewrite D. reflexivity.
Qed.

Lemma markb_wf s : vwf R W s -> vwf R W (markb n tg s).
Proof. intros [A [B C]]. split; auto. Qed.

Lemma markedb_spec s : length (cols s) = R -> markedb n tg s = true -> marked n R reps s.
Proof.
  unfold markedb. rewrite forallb_forall. intros L H j Hj Hh.
  specialize (H j ltac:(apply in_seq; lia)). apply hasb_spec in Hh; auto. rewrite Hh in H.
  exact H.
Qed.

Lemma alldoneb_spec s : alldone n s -> alldoneb n s = true.
Proof.
  intros H. unfold alldoneb. apply forallb_forall. intros j Hj. apply in_seq in Hj. apply H. lia.
Qed.

(* ---------- representative instructions ---------- *)
Lemma forallb_false {A} (f : A -> bool) l : forallb f l = false -> exists x, In x l /\ f x = false.
Proof.
  induction l as [|a l IH]; simpl; [discriminate|]. intros H.
  destruct (f a) eqn:E; simpl in H; [destruct (IH H) as [x [? ?]]; eauto|eauto].
Qed.
Lemma firstrep s r : r < R -> exists r', r' <= r /\ isrep s r' = true /\ getc s r' = getc s r.
Proof.
  induction r as [r IH] using (well_founded_induction lt_wf). intros Hr.
  destruct (isrep s r) eqn:E; [exists r; auto|].
  unfold isrep in E. apply forallb_false in E as [r'' [Hin E]]. apply in_seq in Hin.
  apply negb_false_iff, col_eqb_spec in E.
  destruct (IH r'' ltac:(lia) ltac:(lia)) as [r' [H1 [H2 H3]]].
  exists r'. split; [lia|]. split; auto. congruence.
Qed.

Lemma setn_same {A} (l : list A) d x : d < length l -> setn l d (nth d l x) = l.
Proof. revert d; induction l; intros [|d]; simpl; intros; try lia; auto. f_equal. apply IHl. lia. Qed.

Lemma blend_same c fl x : length fl = length x -> blend c fl x x = x.
Proof. revert x; induction fl; intros [|]; simpl; intros; try lia; auto. f_equal; [destruct (cond_eval _ _); auto|]. apply IHfl. lia. Qed.

Lemma noop_write s d src i : vwf R W s -> d < R -> src < R -> getc s d = getc s src ->
  (i = Mov d src \/ exists c, i = Cmov c d src) -> vstep s i = s.
Proof.
  intros [L1 [L2 L3]] Hd Hs E Hi. destruct s as [cs fs ds]. simpl in *.
  destruct Hi as [->|[c ->]]; simpl; f_equal; rewrite <- E.
  - unfold getc; simpl. apply setn_same. lia.
  - rewrite blend_same. unfold getc; simpl. apply setn_same. lia.
    rewrite L3. symmetry. apply L2. unfold getc. apply nth_In. lia.
Qed.

Lemma isrep_in s d r : d < R -> r < R -> isrep s d = true -> isrep s r = true ->
  In (Cmp d r) (rinstrs R iset s) /\
  (d <> r -> In (Mov d r) (rinstrs R iset s) /\ forall c, iset c = true -> In (Cmov c d r) (rinstrs R iset s)).
Proof.
  intros Hd Hr Ed Er. unfold rinstrs.
  assert (G : forall x, In x (Cmp d r :: (if Nat.eqb d r then [] else Mov d r :: map (fun c => Cmov c d r) (conds iset)))
                -> In x (rinstrs R iset s)).
  { intros x Hx. unfold rinstrs. apply in_flat_map. exists d. split; [apply in_seq; lia|]. rewrite Ed.
    apply in_flat_map. exists r. split; [apply in_seq; lia|]. rewrite Er. exact Hx. }
  split; [apply G; now left|]. intros Hne. apply Nat.eqb_neq in Hne.
  split; [apply G; rewrite Hne; right; now left|].
  intros c Hc. apply G. rewrite Hne. right; right. apply in_map_iff. exists c. split; auto.
  unfold conds. apply filter_In. split; auto. destruct c; simpl; auto.
Qed.

Lemma equiv_dup s a b : length (cols s) = R -> a < R -> b < R -> getc s a = getc s b ->
  Equiv R (tau a b) false s s.
Proof.
  intros L Ha Hb E. split; auto. split; auto. split; [|split; [now rewrite map_negc_false|auto]].
  intros r Hr. unfold tau. destruct (Nat.eqb_spec r a); subst; auto.
  destruct (Nat.eqb_spec r b); subst; auto.
Qed.

Lemma rinstrs_cover s i b : vwf R W s -> instr_wf R i -> instr_in iset i = true ->
  vgood (vstep s i) b -> vstep s i = s \/ exists i', In i' (rinstrs R iset s) /\ vgood (vstep s i') b.
Proof.
  intros Hs Hi Hin Hg. pose proof Hs as [L _]. unfold instr_wf in Hi.
  destruct i as [d src|a b0|c d src]; simpl in Hi.
  - assert (Hd : d < R) by auto. assert (Hsr : src < R) by auto.
    destruct (list_eq_dec Nat.eq_dec (getc s d) (getc s src)) as [E|NE].
    { left. apply (noop_write s d src); auto. }
    right. destruct (firstrep s src Hsr) as [s' [Hs1 [Rs Es]]]. destruct (firstrep s d Hd) as [d' [Hd1 [Rd Ed]]].
    assert (Hne : d' <> s') by (intros ->; congruence).
    exists (Mov d' s'). split; [apply (isrep_in s d' s'); auto; lia|].
    assert (V1 : vstep s (Mov d src) = vstep s (Mov d s')) by (simpl; rewrite Es; reflexivity).
    rewrite V1 in Hg.
    destruct (Nat.eq_dec d' d) as [->|Hdd]; auto.
    apply (equiv_good n R reps iset Hsym (tau d' d) false (vstep s (Mov d s')));
      [apply (tau_ok R reps); lia| |exact Hg].
    replace (Mov d' s') with (ren (tau d' d) false (Mov d s')).
    + apply (equiv_step R reps); [apply (tau_ok R reps); lia|intros r [<-|[<-|[]]]; lia|apply equiv_dup; auto; lia].
    + simpl. unfold tau. rewrite Nat.eqb_refl. destruct (Nat.eqb_spec d d'); [lia|].
      destruct (Nat.eqb_spec s' d'); [congruence|]. destruct (Nat.eqb_spec s' d); [subst; congruence|]. reflexivity.
  - assert (Ha : a < R) by auto. assert (Hb : b0 < R) by auto. right.
    destruct (firstrep s a Ha) as [a' [Ha1 [Ra Ea]]]. destruct (firstrep s b0 Hb) as [b' [Hb1 [Rb Eb]]].
    exists (Cmp a' b'). split; [apply (isrep_in s a' b'); auto; lia|].
    replace (vstep s (Cmp a' b')) with (vstep s (Cmp a b0)); auto. simpl. rewrite Ea, Eb. reflexivity.
  - assert (Hd : d < R) by auto. assert (Hsr : src < R) by auto.
    destruct (list_eq_dec Nat.eq_dec (getc s d) (getc s src)) as [E|NE].
    { left. apply (noop_write s d src); eauto. }
    right. destruct (firstrep s src Hsr) as [s' [Hs1 [Rs Es]]]. destruct (firstrep s d Hd) as [d' [Hd1 [Rd Ed]]].
    assert (Hne : d' <> s') by (intros ->; congruence).
    exists (Cmov c d' s'). split; [apply (isrep_in s d' s'); auto; lia|].
    assert (V1 : vstep s (Cmov c d src) = vstep s (Cmov c d s')) by (simpl; rewrite Es; reflexivity).
    rewrite V1 in Hg.
    destruct (Nat.eq_dec d' d) as [->|Hdd]; auto.
    apply (equiv_good n R reps iset Hsym (tau d' d) false (vstep s (Cmov c d s')));
      [apply (tau_ok R reps); lia| |exact Hg].
    replace (Cmov c d' s') with (ren (tau d' d) false (Cmov c d s')).
    + apply (equiv_step R reps); [apply (tau_ok R reps); lia|intros r [<-|[<-|[]]]; lia|apply equiv_dup; auto; lia].
    + simpl. unfold tau. rewrite Nat.eqb_refl. destruct (Nat.eqb_spec d d'); [lia|].
      destruct (Nat.eqb_spec s' d'); [congruence|]. destruct (Nat.eqb_spec s' d); [subst; congruence|]. reflexivity.
Qed.

Lemma check_entry_inv m s b : check_entry n R reps tg strict iset m (s, b) = true ->
  vwfb R reps s = true /\ markedb n tg s = true /\ alldoneb n s = false /\
  (forall b'', b = S b'' -> forall i, In i (rinstrs R iset s) ->
     covered n reps tg strict m (succ n tg s i) b'' = true).
Proof.
  unfold check_entry. intros H. apply andb_true_iff in H as [H HS]. apply andb_true_iff in H as [H HG].
  apply andb_true_iff in H as [HW HM].
  apply negb_true_iff in HG. split; auto. split; auto. split; auto.
  intros b'' -> i Hi. rewrite forallb_forall in HS. auto.
Qed.

Lemma covered_sound V t b b'' :
  (forall s' b3, In (s', b3) V -> b <= b3 -> ~ vgood s' b) ->
  vwf R W t -> marked n R reps t -> vgood t b -> b <= b'' ->
  covered n reps tg strict (build V) t b'' = true -> False.
Proof.
  intros IH Hcw Hm Hc Hle HS.
  unfold covered in HS. apply orb_true_iff in HS as [HS|HS].
  - destruct (tlook (build V) t) as [b3|] eqn:F; [|discriminate].
    apply Nat.leb_le in HS. apply tlook_build in F.
    apply (IH _ b3 F); [lia|auto].
  - apply (prune_sound n R reps iset Hreps Htd tg Htg strict Hstrict Hsdist HsND t b'' Hcw Hm HS).
    apply vgood_mono with b; [lia|auto].
Qed.

Theorem check_sound V : check n R reps tg strict iset V = true ->
  forall b s b', In (s, b') V -> b <= b' -> ~ vgood s b.
Proof.
  unfold check. intros HC. rewrite forallb_forall in HC.
  induction b as [|b IH]; intros s b' Hin Hle Hg;
    destruct (check_entry_inv _ s b' (HC _ Hin)) as [HW [HM [HG HS]]]; apply vwfb_spec in HW;
    apply markedb_spec in HM; try apply HW.
  - destruct (vgood_inv n R reps iset s 0 HM Hg) as [G|[i [b0 [E _]]]]; [|discriminate].
    rewrite alldoneb_spec in HG by auto. discriminate.
  - destruct (vgood_inv n R reps iset s (S b) HM Hg) as [G|[i [b0 [E [Hi [Hi0 Hgi]]]]]].
    { rewrite alldoneb_spec in HG by auto. discriminate. }
    injection E as E. subst b0.
    destruct b' as [|b'']; [lia|].
    destruct (rinstrs_cover s i b HW Hi Hi0 Hgi) as [Noop|[i' [Hin' Hgi']]].
    { rewrite Noop in Hgi. apply (IH s (S b'') Hin); [lia|exact Hgi]. }
    clear Hgi Hi0. rename i' into i0. assert (Hi' : instr_wf R i0).
    { unfold rinstrs in Hin'. apply in_flat_map in Hin' as [d [Hd Hin']]. apply in_seq in Hd.
      destruct (isrep s d); [|destruct Hin'].
      apply in_flat_map in Hin' as [r [Hr Hin']]. apply in_seq in Hr. destruct (isrep s r); [|destruct Hin'].
      destruct Hin' as [<-|Hin']; [intros x [<-|[<-|[]]]; lia|].
      destruct (Nat.eqb d r); [destruct Hin'|]. destruct Hin' as [<-|Hin']; [intros x [<-|[<-|[]]]; lia|].
      apply in_map_iff in Hin' as [c [<- _]]. intros x [<-|[<-|[]]]; lia. }
    clear i Hi. rename i0 into i. rename Hi' into Hi. rename Hgi' into Hgi. rename Hin' into Hi0.
    pose proof (vwf_step R W s i HW Hi) as Ht.
    destruct (canon_good n R reps iset Hsym (vstep s i) b Ht Hgi) as [Hc Hcw].
    assert (Hlen : length (cols (canon (vstep s i))) = R) by apply Hcw.
    apply (covered_sound V (succ n tg s i) b b'' IH).
    + apply markb_wf, Hcw.
    + apply markb_marked, Hlen.
    + apply markb_good, Hc.
    + lia.
    + apply HS; auto.
Qed.

Theorem certifies_sound V k : certifies n R reps tg strict iset V k = true ->
  forall p o, length p <= k -> prog_ok iset R p -> ~ RelaxedSnap n p o.
Proof.
  unfold certifies. intros H p o Hl Hok Hc. apply andb_true_iff in H as [H1 H2].
  destruct (tlook (build V) (root n R reps tg)) as [b|] eqn:F; [|discriminate].
  apply Nat.leb_le in H2. apply tlook_build in F.
  assert (Hp : forall i, In i p -> instr_wf R i) by (intros; apply Hok; auto).
  assert (Hg : vgood (vinit n R reps) k).
  { exists p. split; auto. split; auto. intros j Hj. right.
    pose proof (snap_reg_lt n R p o Hn1 HnR Hc Hp j Hj) as Hr.
    pose proof (relaxed_snap_cols n R reps p o HnR Hreps Hc Hp j Hj Hr) as E.
    destruct (Nat.le_gt_cases (snd (o j)) (length p)) as [Hle|Hgt].
    - exists (snd (o j)). split; auto. exists (fst (o j)). split; auto.
    - exists (length p). split; auto. exists (fst (o j)). split; auto.
      rewrite firstn_all. rewrite firstn_all2 in E by lia. exact E. }
  destruct (canon_good n R reps iset Hsym (vinit n R reps) k (vwf_init n R reps) Hg) as [Hg' Hw'].
  apply (check_sound V H1 k (root n R reps tg) b F H2). apply markb_good, Hg'.
Qed.

End Sound.

(* ---------- parallel check: chunks by index mod N ---------- *)
Lemma check_from_spec n R reps tg strict iset m N i j V : check_from n R reps tg strict iset m N i j V = true ->
  forall idx e, nth_error V idx = Some e -> Nat.modulo (j + idx) N = i ->
  check_entry n R reps tg strict iset m e = true.
Proof.
  revert j; induction V as [|e0 V IH]; intros j H idx e He Hm; [destruct idx; discriminate|].
  simpl in H. apply andb_true_iff in H as [H1 H2]. destruct idx as [|idx]; simpl in He.
  - injection He as <-. rewrite Nat.add_0_r in Hm. rewrite Hm, Nat.eqb_refl in H1. exact H1.
  - apply (IH (S j) H2 idx e He). rewrite <- Hm. f_equal. lia.
Qed.

Lemma check_chunks n R reps tg strict iset V N : 0 < N ->
  (forall i, i < N -> check_from n R reps tg strict iset (build V) N i 0 V = true) ->
  check n R reps tg strict iset V = true.
Proof.
  intros HN H. unfold check. apply forallb_forall. intros e He.
  apply In_nth_error in He as [idx Hidx].
  apply (check_from_spec n R reps tg strict iset (build V) N (Nat.modulo idx N) 0 V
           (H _ (Nat.mod_upper_bound idx N ltac:(lia))) idx e Hidx). reflexivity.
Qed.
