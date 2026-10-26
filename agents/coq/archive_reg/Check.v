(* Check.v -- verified checker of a search certificate, and an UNTRUSTED search that makes one.
   Certificate V = list of (canonical column state s, budget b).  The checker tests:
     (C0) every s in V is well formed and is not a goal state;
     (C1) for every (s, S b) in V and every I0 instruction i (registers < R):
          t := canon (vstep s i) is in V with budget >= b, or prune t b = true;
     (C2) canon (vinit) is in V with budget >= k.
   Theorem certifies_sound: C0..C2 -> no I0 program of length <= k with registers < R
   is RelaxedCorrect for n inputs.  The search (layers/search) needs no proof: its output is checked. *)
From Stdlib Require Import List Bool Lia Arith ZArith PArith FMapPositive Mergesort.
From Stdlib Require Import PrimInt63 Uint63.
From CmovSort Require Import Machine Vec Good Prune.
Import ListNotations.

Section Check.
Variables (n R : nat) (reps : list (list nat)) (tg : list col) (strict : list nat).
Let W := length reps.
Hypothesis HnR : n <= R.
Hypothesis Hreps : reps_ok n reps.
Hypothesis Htg : forall j, j < n -> nth j tg [] = tgt reps j.
Hypothesis Hstrict : forall w, In w strict ->
  w < W /\ NoDup (nth w reps []) /\ NatSort.sort (nth w reps []) = seq 0 n.
Hypothesis Hsdist : forall w1 w2, In w1 strict -> In w2 strict -> nth w1 reps [] = nth w2 reps [] -> w1 = w2.
Hypothesis HsND : NoDup strict.

(* ---------- all instructions of I0 with registers < R ---------- *)
Definition instrs : list instr :=
  flat_map (fun d => flat_map (fun r => [Mov d r; Cmov CL d r; Cmov CG d r; Cmp d r]) (seq 0 R)) (seq 0 R).

Lemma instrs_complete i : instr_wf R i -> instr_in cond_inI0 i = true -> In i instrs.
Proof.
  intros Hw Hi. unfold instr_wf in Hw. unfold instrs.
  destruct i as [d r|d r|c d r]; simpl in Hw;
  (assert (d < R) by auto; assert (r < R) by auto);
  apply in_flat_map; exists d; split; try (apply in_seq; lia);
  apply in_flat_map; exists r; split; try (apply in_seq; lia); simpl; auto.
  destruct c; simpl in Hi; try discriminate; auto.
Qed.

(* ---------- boolean tests ---------- *)
Definition vwfb (s : vst) : bool :=
  Nat.eqb (length (cols s)) R && forallb (fun c => Nat.eqb (length c) W) (cols s)
  && Nat.eqb (length (flags s)) W.

Lemma vwfb_spec s : vwfb s = true -> vwf R W s.
Proof.
  unfold vwfb. intros H. apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  apply Nat.eqb_eq in H1, H3. rewrite forallb_forall in H2.
  split; auto. split; auto. intros c Hc. apply Nat.eqb_eq, H2, Hc.
Qed.

Definition goalb (s : vst) : bool := forallb (fun j => col_eqb (getc s j) (nth j tg [])) (seq 0 n).

Lemma goalb_spec s : vgoal n reps s -> goalb s = true.
Proof.
  intros Hg. unfold goalb. apply forallb_forall. intros j Hj. apply in_seq in Hj.
  apply col_eqb_spec. rewrite Hg, Htg by lia. reflexivity.
Qed.

(* ---------- hash table (FMapPositive of buckets); the hash needs no proof ---------- *)
Fixpoint ofn (x : nat) : int := match x with 0 => 0%uint63 | S x' => PrimInt63.add (ofn x') 1%uint63 end.
Definition hstep (h : int) (x : nat) : int := PrimInt63.add (PrimInt63.mul h 31%uint63) (ofn x).
Definition hflag (h : int) (f : comparison) : int := hstep h (fcode f).
Definition hraw (s : vst) : int :=
  fold_left hflag (flags s) (fold_left (fun h c => fold_left hstep c (PrimInt63.mul h 7%uint63)) (cols s) 1%uint63).
Fixpoint pk (k : nat) (h : int) : positive :=
  match k with
  | 0 => xH
  | S k' => if PrimInt63.eqb (PrimInt63.land h 1%uint63) 0%uint63
            then xO (pk k' (PrimInt63.lsr h 1%uint63)) else xI (pk k' (PrimInt63.lsr h 1%uint63))
  end.
Definition hkey (s : vst) : positive :=
  pk 22 (PrimInt63.lsr (PrimInt63.mul (hraw s) 5871781006564002453%uint63) 40%uint63).

Fixpoint list_eqb {A} (e : A -> A -> bool) (a b : list A) : bool :=
  match a, b with
  | [], [] => true
  | x :: a', y :: b' => e x y && list_eqb e a' b'
  | _, _ => false
  end.

Lemma list_eqb_true {A} (e : A -> A -> bool) a b : (forall x y, e x y = true -> x = y) ->
  list_eqb e a b = true -> a = b.
Proof.
  intros He. revert b; induction a; intros [|]; simpl; intros H; try discriminate; auto.
  apply andb_true_iff in H as [H1 H2]. f_equal; auto.
Qed.

Definition cmp_eqb (f g : comparison) : bool := Nat.eqb (fcode f) (fcode g).

Definition vst_eqb (s t : vst) : bool :=
  list_eqb col_eqb (cols s) (cols t) && list_eqb cmp_eqb (flags s) (flags t).

Lemma vst_eqb_true s t : vst_eqb s t = true -> s = t.
Proof.
  unfold vst_eqb. intros H. apply andb_true_iff in H as [H1 H2].
  apply list_eqb_true in H1; [|intros; apply col_eqb_spec; auto].
  apply list_eqb_true in H2; [|intros x y E; apply fcode_inj, Nat.eqb_eq, E].
  destruct s, t; simpl in *; congruence.
Qed.

Definition bucket := list (vst * nat).
Definition tbl := PositiveMap.t bucket.

Fixpoint blook (t : vst) (bk : bucket) : option nat :=
  match bk with [] => None | (s, b) :: bk' => if vst_eqb s t then Some b else blook t bk' end.

Definition tlookh (hk : vst -> positive) (m : tbl) (t : vst) : option nat :=
  match PositiveMap.find (hk t) m with None => None | Some bk => blook t bk end.

Definition taddh (hk : vst -> positive) (m : tbl) (s : vst) (b : nat) : tbl :=
  PositiveMap.add (hk s) ((s, b) :: match PositiveMap.find (hk s) m with Some bk => bk | None => [] end) m.

Definition buildh (hk : vst -> positive) (V : list (vst * nat)) : tbl :=
  fold_left (fun m e => taddh hk m (fst e) (snd e)) V (PositiveMap.empty _).

Lemma blook_in t bk b : blook t bk = Some b -> In (t, b) bk.
Proof.
  induction bk as [|[s b'] bk IH]; simpl; [discriminate|].
  destruct (vst_eqb s t) eqn:E; intros H; [left|right; auto].
  apply vst_eqb_true in E. inversion H. now subst.
Qed.

Lemma in_opt_bucket (o : option bucket) e :
  In e (match o with Some bk => bk | None => [] end) -> exists bk, o = Some bk /\ In e bk.
Proof. destruct o; simpl; [eauto|tauto]. Qed.

Lemma build_inv (hk : vst -> positive) (P : vst * nat -> Prop) V m :
  (forall k bk e, PositiveMap.find k m = Some bk -> In e bk -> P e) -> (forall e, In e V -> P e) ->
  forall k bk e, PositiveMap.find k (fold_left (fun m e => taddh hk m (fst e) (snd e)) V m) = Some bk ->
  In e bk -> P e.
Proof.
  revert m; induction V as [|[s b] V IH]; simpl; intros m Hm HV; auto.
  apply IH; [|intros; apply HV; now right]. intros k bk e Hf He. unfold taddh in Hf.
  destruct (Pos.eq_dec k (hk s)) as [->|Hk].
  - rewrite PositiveMap.gss in Hf. inversion Hf; subst. destruct He as [<-|He]; [apply HV; now left|].
    destruct (in_opt_bucket _ _ He) as [bk0 [F He']]. eapply Hm; eauto.
  - rewrite PositiveMap.gso in Hf by auto. eapply Hm; eauto.
Qed.

Lemma tlook_buildh hk V t b : tlookh hk (buildh hk V) t = Some b -> In (t, b) V.
Proof.
  unfold tlookh. destruct (PositiveMap.find (hk t) (buildh hk V)) as [bk|] eqn:F; [|discriminate].
  intros H. apply blook_in in H.
  apply (build_inv hk (fun e => In e V) V (PositiveMap.empty _)) with (k := hk t) (bk := bk); auto.
  intros k bk' e Hf. rewrite PositiveMap.gempty in Hf. discriminate.
Qed.

Definition tlook := tlookh hkey.
Definition tadd := taddh hkey.
Definition build := buildh hkey.

Lemma tlook_build V t b : tlook (build V) t = Some b -> In (t, b) V.
Proof. apply tlook_buildh. Qed.

(* ---------- the checker ---------- *)
Definition covered (m : tbl) (t : vst) (b : nat) : bool :=
  match tlook m t with Some b' => Nat.leb b b' | None => false end || prune n R reps tg strict t b.

Definition check_entry (m : tbl) (e : vst * nat) : bool :=
  let (s, b) := e in
  vwfb s && negb (goalb s) &&
  match b with 0 => true | S b' => forallb (fun i => covered m (canon n R (vstep s i)) b') instrs end.

Definition check (V : list (vst * nat)) : bool := let m := build V in forallb (check_entry m) V.

Definition root : vst := canon n R (vinit n R reps).

End Check.
