(* Good.v -- "vgood s b": some I0 program of length <= b drives the column state s to the goal.
   Symmetries: (1) any injective renaming of registers that fixes P0..P{n-1} (scratch permutation),
   (2) flag negation (lt <-> gt, with cmovl <-> cmovg and cmp a b -> cmp b a).
   canon = sort the scratch columns by adjacent swaps, then make the first non-eq flag "lt".
   Theorem canon_good: vgood s b -> vgood (canon s) b. *)
From Stdlib Require Import List Bool Lia Arith ZArith.
From CmovSort Require Import Machine Vec.
Import ListNotations.

Section Good.
Variables (n R : nat) (reps : list (list nat)).
Let W := length reps.

Definition vgood (s : vst) (b : nat) : Prop :=
  exists p, length p <= b /\ prog_ok R p /\ vgoal n reps (vrun p s).

Lemma vgood_mono s b b' : b <= b' -> vgood s b -> vgood s b'.
Proof. intros H [p [H1 H2]]. exists p. split; [lia|auto]. Qed.

Lemma vgood_inv s b : vgood s b ->
  vgoal n reps s \/ exists i b', b = S b' /\ instr_wf R i /\ instr_in cond_inI0 i = true /\
                                 vgood (vstep s i) b'.
Proof.
  intros [[|i p] [Hl [Hok Hg]]]; simpl in *; [now left|right].
  destruct b as [|b']; [lia|]. exists i, b'. split; auto. split; [|split].
  - apply Hok; now left.
  - apply Hok; now left.
  - exists p. split; [lia|]. split; auto. intros j Hj. apply Hok. now right.
Qed.

(* ---------- renaming ---------- *)
Definition negc (neg : bool) (f : comparison) : comparison := if neg then CompOpp f else f.
Definition swapc (c : cond) : cond := match c with CL => CG | CG => CL | CLE => CGE | CGE => CLE end.

Definition ren (pi : nat -> nat) (neg : bool) (i : instr) : instr :=
  match i with
  | Mov d r => Mov (pi d) (pi r)
  | Cmp a b => if neg then Cmp (pi b) (pi a) else Cmp (pi a) (pi b)
  | Cmov c d r => Cmov (if neg then swapc c else c) (pi d) (pi r)
  end.

Definition perm_ok (pi : nat -> nat) : Prop :=
  (forall r, r < R -> pi r < R) /\
  (forall r1 r2, r1 < R -> r2 < R -> pi r1 = pi r2 -> r1 = r2) /\
  (forall j, j < n -> pi j = j).

Definition Equiv (pi : nat -> nat) (neg : bool) (s s' : vst) : Prop :=
  length (cols s) = R /\ length (cols s') = R /\
  (forall r, r < R -> getc s' (pi r) = getc s r) /\
  flags s' = map (negc neg) (flags s).

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

Lemma getc_setn (l : list col) f d v r : d < length l ->
  getc (VS (setn l d v) f) r = if Nat.eqb r d then v else getc (VS l f) r.
Proof. intros H. unfold getc; simpl. apply nth_setn; auto. Qed.

Lemma equiv_step pi neg s s' i : perm_ok pi -> instr_wf R i -> Equiv pi neg s s' ->
  Equiv pi neg (vstep s i) (vstep s' (ren pi neg i)).
Proof.
  intros [Pb [Pi Pf]] Hi [L1 [L2 [Hc Hf]]]. unfold instr_wf in Hi.
  destruct s as [cs fs]; destruct s' as [cs' fs']; simpl in *.
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

Lemma equiv_good pi neg s s' b : perm_ok pi -> n <= R -> Equiv pi neg s s' -> vgood s b -> vgood s' b.
Proof.
  intros HP HnR HE [p [Hl [Hok Hg]]].
  exists (map (ren pi neg) p). split; [now rewrite length_map|]. split.
  - intros i Hi. apply in_map_iff in Hi as [i0 [<- Hi0]].
    destruct (Hok i0 Hi0) as [Hw Hs]. destruct HP as [Pb _].
    unfold instr_wf in *. split.
    + destruct i0; destruct neg; simpl in *; intros r [<-|[<-|[]]]; apply Pb, Hw; simpl; auto.
    + destruct i0; destruct neg; simpl in *; auto. destruct c; simpl in *; auto.
  - pose proof (equiv_run pi neg p s s' HP (fun i H => proj1 (Hok i H)) HE) as [_ [_ [Hc _]]].
    intros j Hj. destruct HP as [_ [_ Pf]].
    transitivity (getc (vrun (map (ren pi neg) p) s') (pi j)); [now rewrite Pf|].
    rewrite Hc by lia. apply Hg; auto.
Qed.

(* ---------- swaps and flag negation ---------- *)
Definition tau (i j r : nat) : nat := if Nat.eqb r i then j else if Nat.eqb r j then i else r.

Definition swapregs (i j : nat) (s : vst) : vst :=
  VS (setn (setn (cols s) i (getc s j)) j (getc s i)) (flags s).

Lemma tau_ok i j : n <= i < R -> n <= j < R -> perm_ok (tau i j).
Proof.
  intros Hi Hj. unfold tau. split; [|split].
  - intros r Hr. destruct (Nat.eqb r i), (Nat.eqb r j); lia.
  - intros r1 r2 H1 H2.
    destruct (Nat.eqb_spec r1 i), (Nat.eqb_spec r1 j), (Nat.eqb_spec r2 i), (Nat.eqb_spec r2 j); lia.
  - intros r Hr. destruct (Nat.eqb_spec r i), (Nat.eqb_spec r j); lia.
Qed.

Lemma swap_equiv i j s : n <= i < R -> n <= j < R -> length (cols s) = R ->
  Equiv (tau i j) false s (swapregs i j s).
Proof.
  intros Hi Hj L. unfold Equiv, swapregs, getc; simpl. rewrite !length_setn.
  split; auto. split; auto. split; [|now rewrite map_negc_false].
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

Definition negflags (s : vst) : vst := VS (cols s) (map CompOpp (flags s)).

Lemma neg_equiv s : length (cols s) = R -> Equiv (fun r => r) true s (negflags s).
Proof. intros L. unfold Equiv, negflags; simpl. repeat split; auto. Qed.

Lemma id_ok : perm_ok (fun r => r).
Proof. repeat split; auto. Qed.

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

Definition fpass (s : vst) : vst := fold_left cswap (seq n (R - n - 1)) s.
Definition bpass (s : vst) : vst := fold_left cswap (rev (seq n (R - n - 1))) s.

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

Lemma cswap_good i s b : n <= i -> S i < R -> vwf R W s -> n <= R ->
  vwf R W (cswap s i) /\ (vgood s b -> vgood (cswap s i) b).
Proof.
  intros H1 H2 Hw HnR. unfold cswap. destruct (lexc _ _); auto.
  split. apply swapregs_wf; auto; lia.
  apply equiv_good with (tau i (S i)) false; auto.
  apply tau_ok; lia. apply swap_equiv; try lia. apply Hw.
Qed.

Lemma fold_cswap_good l s b : (forall i, In i l -> n <= i /\ S i < R) -> vwf R W s -> n <= R ->
  vwf R W (fold_left cswap l s) /\ (vgood s b -> vgood (fold_left cswap l s) b).
Proof.
  revert s; induction l as [|i l IH]; simpl; intros s Hl Hw HnR.
  { split; auto. }
  assert (Hi : n <= i /\ S i < R) by (apply Hl; now left).
  destruct (cswap_good i s b (proj1 Hi) (proj2 Hi) Hw HnR) as [A B].
  assert (Hl' : forall j, In j l -> n <= j /\ S j < R) by (intros; apply Hl; now right).
  destruct (IH (cswap s i) Hl' A HnR) as [C D].
  split; [exact C|]. intros G. apply D, B, G.
Qed.

Lemma canon_good s b : vwf R W s -> n <= R -> vgood s b -> vgood (canon s) b /\ vwf R W (canon s).
Proof.
  intros Hw HnR Hg.
  assert (Hl1 : forall i, In i (seq n (R - n - 1)) -> n <= i /\ S i < R)
    by (intros i Hi; apply in_seq in Hi; lia).
  assert (Hl2 : forall i, In i (rev (seq n (R - n - 1))) -> n <= i /\ S i < R)
    by (intros i Hi; apply Hl1, in_rev, Hi).
  pose proof (fold_cswap_good (seq n (R - n - 1)) s b Hl1 Hw HnR) as [A B]. fold (fpass s) in A, B.
  pose proof (fold_cswap_good (rev (seq n (R - n - 1))) (fpass s) b Hl2 A HnR) as [C D].
  fold (bpass (fpass s)) in C, D.
  unfold canon, normflags. destruct (firstne _).
  1,2: split; auto.
  split.
  - apply (equiv_good (fun r => r) true (bpass (fpass s))); auto. apply id_ok. apply neg_equiv, C.
  - destruct C as [C1 [C2 C3]]. split; auto. split; auto. simpl. now rewrite length_map.
Qed.

End Good.
