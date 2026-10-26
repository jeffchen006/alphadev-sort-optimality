(* Good.v -- "vgood s b" in the snapshot-output model M_out (MODEL.md 4.3):
   some program of length <= b (instructions in iset, registers < R) such that every output j
   is done in s, or some register holds the target column tgt j at some step (step 0 = now).
   Symmetries: (1) any injective renaming of the registers < R (outputs are snapshots, so the P registers
   are not special any more), (2) flag negation (lt <-> gt, cmovl <-> cmovg, cmovle <-> cmovge, cmp a b -> cmp b a).
   canon = sort all columns by adjacent swaps, then make the first non-eq flag "lt".
   Theorem canon_good: vgood s b -> vgood (canon s) b. *)
From Stdlib Require Import List Bool Lia Arith ZArith.
From CmovSort Require Import Machine Vec.
Import ListNotations.

Definition negc (neg : bool) (f : comparison) : comparison := if neg then CompOpp f else f.
Definition swapc (c : cond) : cond := match c with CL => CG | CG => CL | CLE => CGE | CGE => CLE end.

Lemma swapc_I0 c : cond_inI0 (swapc c) = cond_inI0 c.
Proof. destruct c; reflexivity. Qed.
Lemma swapc_I1 c : cond_inI1 (swapc c) = cond_inI1 c.
Proof. destruct c; reflexivity. Qed.

Lemma getc_setn (l : list col) f dd d v r : d < length l ->
  getc (VS (setn l d v) f dd) r = if Nat.eqb r d then v else getc (VS l f dd) r.
Proof. intros H. unfold getc; simpl. apply nth_setn; auto. Qed.

Lemma vrun_dn p s : dn (vrun p s) = dn s.
Proof. revert s; induction p as [|i p IH]; simpl; intros s; auto. rewrite IH. destruct i; reflexivity. Qed.

Lemma vrun_setdn q s d : vrun q (VS (cols s) (flags s) d) = VS (cols (vrun q s)) (flags (vrun q s)) d.
Proof.
  revert s; induction q as [|i q IH]; simpl; intros s; [destruct s; reflexivity|].
  replace (vstep (VS (cols s) (flags s) d) i) with (VS (cols (vstep s i)) (flags (vstep s i)) d)
    by (destruct s, i; reflexivity).
  apply IH.
Qed.

Section Good.
Variables (n R : nat) (reps : list (list nat)) (iset : cond -> bool).
Hypothesis Hsym : forall c, iset (swapc c) = iset c.
Let W := length reps.

Definition has (s : vst) (j : nat) : Prop := exists r, r < R /\ getc s r = tgt reps j.
Definition achieved (p : program) (s : vst) (j : nat) : Prop :=
  exists t, t <= length p /\ has (vrun (firstn t p) s) j.
Definition isdone (s : vst) (j : nat) : Prop := nth j (dn s) false = true.

Definition vgood (s : vst) (b : nat) : Prop :=
  exists p, length p <= b /\ prog_ok iset R p /\ forall j, j < n -> isdone s j \/ achieved p s j.

Definition marked (s : vst) : Prop := forall j, j < n -> has s j -> isdone s j.
Definition alldone (s : vst) : Prop := forall j, j < n -> isdone s j.

Lemma vgood_mono s b b' : b <= b' -> vgood s b -> vgood s b'.
Proof. intros H [p [H1 H2]]. exists p. split; [lia|auto]. Qed.

Lemma vgood_inv s b : marked s -> vgood s b ->
  alldone s \/ exists i b', b = S b' /\ instr_wf R i /\ instr_in iset i = true /\ vgood (vstep s i) b'.
Proof.
  intros Hm [[|i p] [Hl [Hok Hg]]].
  - left. intros j Hj. destruct (Hg j Hj) as [D|[t [Ht Hh]]]; auto.
    simpl in Ht. assert (t = 0) by lia. subst. apply Hm; auto.
  - simpl in Hl. destruct b as [|b']; [lia|]. right. exists i, b'.
    split; auto. split; [apply Hok; now left|]. split; [apply Hok; now left|].
    exists p. split; [lia|]. split; [intros i' Hi'; apply Hok; now right|].
    intros j Hj. destruct (Hg j Hj) as [D|[t [Ht Hh]]].
    + left. unfold isdone in *. destruct i; exact D.
    + destruct t as [|t].
      * left. assert (isdone s j) by (apply Hm; auto). unfold isdone in *. destruct i; auto.
      * right. exists t. simpl in Ht. split; [lia|]. exact Hh.
Qed.

(* more done outputs, same columns and flags: vgood is kept *)
Lemma vgood_more_done s s' b : cols s' = cols s -> flags s' = flags s ->
  (forall j, j < n -> isdone s j -> isdone s' j) -> vgood s b -> vgood s' b.
Proof.
  intros Hc Hf Hd [p [Hl [Hok Hg]]]. exists p. split; auto. split; auto.
  assert (E : forall q, cols (vrun q s') = cols (vrun q s)).
  { intros q. destruct s as [c f d], s' as [c' f' d']; simpl in *; subst.
    pose proof (vrun_setdn q (VS c f d) d') as V. simpl in V. rewrite V. reflexivity. }
  intros j Hj. destruct (Hg j Hj) as [D|[t [Ht [r [Hr Hh]]]]]; [left; auto|].
  right. exists t. split; auto. exists r. split; auto. unfold getc in *. rewrite E. exact Hh.
Qed.

(* ---------- renaming ---------- *)
Definition ren (pi : nat -> nat) (neg : bool) (i : instr) : instr :=
  match i with
  | Mov d r => Mov (pi d) (pi r)
  | Cmp a b => if neg then Cmp (pi b) (pi a) else Cmp (pi a) (pi b)
  | Cmov c d r => Cmov (if neg then swapc c else c) (pi d) (pi r)
  end.

Definition perm_ok (pi : nat -> nat) : Prop :=
  (forall r, r < R -> pi r < R) /\
  (forall r1 r2, r1 < R -> r2 < R -> pi r1 = pi r2 -> r1 = r2).

Definition Equiv (pi : nat -> nat) (neg : bool) (s s' : vst) : Prop :=
  length (cols s) = R /\ length (cols s') = R /\
  (forall r, r < R -> getc s' (pi r) = getc s r) /\
  flags s' = map (negc neg) (flags s) /\ dn s' = dn s.

Lemma blend_neg (c : cond) (neg : bool) (fl : list comparison) (x y : col) :
  blend (if neg then swapc c else c) (map (negc neg) fl) x y = blend c fl x y.
Proof.
  revert x y; induction fl; intros [|] [|]; simpl; auto. f_equal; auto.
  destruct neg, c, a; reflexivity.
Qed.

Lemma cmpcol_swap (x y : col) : cmpcol y x = map CompOpp (cmpcol x y).
Proof.
  revert y; induction x; intros [|]; simpl; auto. f_equal; auto. apply Nat.compare_antisym.
Qed.

Lemma map_negc_false (l : list comparison) : map (negc false) l = l.
Proof. induction l; simpl; f_equal; auto. Qed.

Lemma equiv_step pi neg s s' i : perm_ok pi -> instr_wf R i -> Equiv pi neg s s' ->
  Equiv pi neg (vstep s i) (vstep s' (ren pi neg i)).
Proof.
  intros [Pb Pi] Hi [L1 [L2 [Hc [Hf Hd]]]]. unfold instr_wf in Hi.
  destruct s as [cs fs ds]; destruct s' as [cs' fs' ds']; simpl in *.
  destruct i as [d r|a b|c d r]; simpl in Hi.
  - assert (d < R) by auto. assert (r < R) by auto. assert (pi d < R) by auto.
    repeat split; simpl; rewrite ?length_setn; auto.
    intros r' Hr'. rewrite !getc_setn by lia.
    destruct (Nat.eqb_spec r' d), (Nat.eqb_spec (pi r') (pi d)); subst; auto.
    + exfalso; auto.
    + exfalso; apply n0, Pi; auto.
  - assert (a < R) by auto. assert (b < R) by auto.
    destruct neg; simpl; repeat split; auto; rewrite !Hc by auto.
    + rewrite cmpcol_swap. reflexivity.
    + now rewrite map_negc_false.
  - assert (d < R) by auto. assert (r < R) by auto. assert (pi d < R) by auto.
    repeat split; simpl; rewrite ?length_setn; auto.
    intros r' Hr'. rewrite !getc_setn by lia.
    destruct (Nat.eqb_spec r' d), (Nat.eqb_spec (pi r') (pi d)); subst.
    + rewrite !Hc by auto. apply blend_neg.
    + exfalso; auto.
    + exfalso; apply n0, Pi; auto.
    + apply Hc; auto.
Qed.

Lemma equiv_run pi neg p s s' : perm_ok pi -> (forall i, In i p -> instr_wf R i) -> Equiv pi neg s s' ->
  Equiv pi neg (vrun p s) (vrun (map (ren pi neg) p) s').
Proof.
  revert s s'; induction p; simpl; intros; auto.
  apply IHp; auto. apply equiv_step; auto.
Qed.

Lemma equiv_good pi neg s s' b : perm_ok pi -> Equiv pi neg s s' -> vgood s b -> vgood s' b.
Proof.
  intros HP HE [p [Hl [Hok Hg]]].
  assert (Hw : forall i, In i p -> instr_wf R i) by (intros; apply Hok; auto).
  exists (map (ren pi neg) p). split; [now rewrite length_map|]. split.
  - intros i Hi. apply in_map_iff in Hi as [i0 [<- Hi0]].
    destruct (Hok i0 Hi0) as [Hw0 Hs]. destruct HP as [Pb _].
    unfold instr_wf in *. split.
    + destruct i0; destruct neg; simpl in *; intros r [<-|[<-|[]]]; apply Pb, Hw0; simpl; auto.
    + destruct i0; destruct neg; simpl in *; auto. rewrite Hsym. auto.
  - intros j Hj. destruct HE as [L1 [L2 [Hc [Hf Hd]]]].
    destruct (Hg j Hj) as [D|[t [Ht [r [Hr Hh]]]]].
    + left. unfold isdone. rewrite Hd. exact D.
    + right. exists t. split; [now rewrite length_map|].
      assert (Hwt : forall i, In i (firstn t p) -> instr_wf R i) by (apply firstn_wf; auto).
      pose proof (equiv_run pi neg (firstn t p) s s' HP Hwt (conj L1 (conj L2 (conj Hc (conj Hf Hd)))))
        as [_ [_ [Hc' _]]].
      exists (pi r). split; [apply HP; auto|]. rewrite firstn_map. rewrite Hc' by auto. exact Hh.
Qed.

(* ---------- swaps and flag negation ---------- *)
Definition tau (i j r : nat) : nat := if Nat.eqb r i then j else if Nat.eqb r j then i else r.

Definition swapregs (i j : nat) (s : vst) : vst :=
  VS (setn (setn (cols s) i (getc s j)) j (getc s i)) (flags s) (dn s).

Lemma tau_ok i j : i < R -> j < R -> perm_ok (tau i j).
Proof.
  intros Hi Hj. unfold tau. split.
  - intros r Hr. destruct (Nat.eqb r i), (Nat.eqb r j); lia.
  - intros r1 r2 H1 H2.
    destruct (Nat.eqb_spec r1 i), (Nat.eqb_spec r1 j), (Nat.eqb_spec r2 i), (Nat.eqb_spec r2 j); lia.
Qed.

Lemma swap_equiv i j s : i < R -> j < R -> length (cols s) = R ->
  Equiv (tau i j) false s (swapregs i j s).
Proof.
  intros Hi Hj L. unfold Equiv, swapregs, getc; simpl. rewrite !length_setn.
  split; auto. split; auto. split; [|split; [now rewrite map_negc_false|auto]].
  intros r Hr. unfold tau.
  destruct (Nat.eqb_spec r i), (Nat.eqb_spec r j); subst.
  - rewrite nth_setn by (rewrite length_setn; lia). rewrite Nat.eqb_refl. reflexivity.
  - rewrite nth_setn by (rewrite length_setn; lia). rewrite Nat.eqb_refl. reflexivity.
  - rewrite nth_setn by (rewrite length_setn; lia). rewrite (proj2 (Nat.eqb_neq i j)) by auto.
    rewrite nth_setn by lia. rewrite Nat.eqb_refl. reflexivity.
  - rewrite nth_setn by (rewrite length_setn; lia).
    rewrite (proj2 (Nat.eqb_neq r j)) by auto.
    rewrite nth_setn by lia. rewrite (proj2 (Nat.eqb_neq r i)) by auto. reflexivity.
Qed.

Definition negflags (s : vst) : vst := VS (cols s) (map CompOpp (flags s)) (dn s).

Lemma neg_equiv s : length (cols s) = R -> Equiv (fun r => r) true s (negflags s).
Proof. intros L. unfold Equiv, negflags; simpl. repeat split; auto. Qed.

Lemma id_ok : perm_ok (fun r => r).
Proof. split; auto. Qed.

(* ---------- canonical form ---------- *)
Fixpoint lexc (a b : list nat) : comparison :=
  match a, b with
  | [], [] => Eq
  | [], _ => Lt
  | _, [] => Gt
  | x :: a', y :: b' => match Nat.compare x y with Eq => lexc a' b' | c => c end
  end.

Definition cswap (s : vst) (i : nat) : vst :=
  match lexc (getc s i) (getc s (S i)) with Gt => swapregs i (S i) s | _ => s end.

Definition fpass (s : vst) : vst := fold_left cswap (seq 0 (R - 1)) s.
Definition bpass (s : vst) : vst := fold_left cswap (rev (seq 0 (R - 1))) s.

Fixpoint firstne (fl : list comparison) : comparison :=
  match fl with [] => Eq | Eq :: t => firstne t | f :: _ => f end.

Definition normflags (s : vst) : vst := match firstne (flags s) with Gt => negflags s | _ => s end.

(* One forward and one backward pass sort a sorted list in which one entry changed. *)
Definition canon (s : vst) : vst := normflags (bpass (fpass s)).

Lemma swapregs_wf i j s : i < R -> j < R -> vwf R W s -> vwf R W (swapregs i j s).
Proof.
  intros Hi Hj [L1 [L2 L3]]. unfold swapregs, vwf; simpl. rewrite !length_setn.
  split; auto. split; auto. intros c Hc.
  destruct (in_setn _ _ _ _ Hc) as [H1|H1].
  - destruct (in_setn _ _ _ _ H1) as [H3|H3]; auto. subst c. apply L2; unfold getc; apply nth_In; lia.
  - subst c. apply L2; unfold getc; apply nth_In; lia.
Qed.

Lemma cswap_good i s b : S i < R -> vwf R W s ->
  vwf R W (cswap s i) /\ (vgood s b -> vgood (cswap s i) b).
Proof.
  intros H2 Hw. unfold cswap. destruct (lexc _ _); auto.
  split. apply swapregs_wf; auto; lia.
  apply equiv_good with (tau i (S i)) false; auto.
  apply tau_ok; lia. apply swap_equiv; try lia. apply Hw.
Qed.

Lemma fold_cswap_good l s b : (forall i, In i l -> S i < R) -> vwf R W s ->
  vwf R W (fold_left cswap l s) /\ (vgood s b -> vgood (fold_left cswap l s) b).
Proof.
  revert s; induction l as [|i l IH]; simpl; intros s Hl Hw.
  { split; auto. }
  assert (Hi : S i < R) by (apply Hl; now left).
  destruct (cswap_good i s b Hi Hw) as [A B].
  assert (Hl' : forall j, In j l -> S j < R) by (intros; apply Hl; now right).
  destruct (IH (cswap s i) Hl' A) as [C D].
  split; [exact C|]. intros G. apply D, B, G.
Qed.

Lemma canon_good s b : vwf R W s -> vgood s b -> vgood (canon s) b /\ vwf R W (canon s).
Proof.
  intros Hw Hg.
  assert (Hl1 : forall i, In i (seq 0 (R - 1)) -> S i < R)
    by (intros i Hi; apply in_seq in Hi; lia).
  assert (Hl2 : forall i, In i (rev (seq 0 (R - 1))) -> S i < R)
    by (intros i Hi; apply Hl1, in_rev, Hi).
  pose proof (fold_cswap_good (seq 0 (R - 1)) s b Hl1 Hw) as [A B]. fold (fpass s) in A, B.
  pose proof (fold_cswap_good (rev (seq 0 (R - 1))) (fpass s) b Hl2 A) as [C D].
  fold (bpass (fpass s)) in C, D.
  unfold canon, normflags. destruct (firstne _).
  1,2: split; auto.
  split.
  - apply (equiv_good (fun r => r) true (bpass (fpass s))); auto. apply id_ok. apply neg_equiv, C.
  - destruct C as [C1 [C2 C3]]. split; auto. split; auto. simpl. now rewrite length_map.
Qed.

Lemma canon_dn s : dn (canon s) = dn s.
Proof.
  assert (F : forall l s, dn (fold_left cswap l s) = dn s).
  { induction l as [|i l IH]; simpl; intros s0; auto. rewrite IH. unfold cswap.
    destruct (lexc _ _); reflexivity. }
  unfold canon, normflags, bpass, fpass. destruct (firstne _); simpl; rewrite !F; reflexivity.
Qed.

End Good.
