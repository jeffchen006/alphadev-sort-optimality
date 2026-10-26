(* Check.v -- checker of a search certificate (definitions), M_out model.
   Certificate V = list of (column state s with done mask, budget b).  check V tests:
     (C0) every s in V is well formed, marked (a present target is done) and not all done;
     (C1) for every (s, S b) in V and every instruction i of iset with registers < R:
          t := markb (canon (vstep s i)) is in V with budget >= b, or prune t b = true;
   certifies V k also tests (C2) root = markb (canon vinit) is in V with budget >= k.
   Soundness: Sound.v.  The hash function is not trusted (buckets compare states exactly). *)
From Stdlib Require Import List Bool Lia Arith ZArith PArith FMapPositive Mergesort.
From Stdlib Require Import PrimInt63 Uint63.
From CmovSort Require Import Machine Vec Good Prune.
Import ListNotations.

Section Check.
Variables (n R : nat) (reps : list (list nat)) (tg : list col) (strict : list nat) (iset : cond -> bool).
Let W := length reps.

(* ---------- all instructions of iset with registers < R ---------- *)
Definition conds : list cond := filter iset [CL; CG; CLE; CGE].

Definition instrs : list instr :=
  flat_map (fun d => flat_map (fun r => Mov d r :: Cmp d r :: map (fun c => Cmov c d r) conds)
                               (seq 0 R)) (seq 0 R).

Lemma instrs_complete i : instr_wf R i -> instr_in iset i = true -> In i instrs.
Proof.
  intros Hw Hi. unfold instr_wf in Hw. unfold instrs.
  destruct i as [d r|d r|c d r]; simpl in Hw;
  (assert (d < R) by auto; assert (r < R) by auto);
  apply in_flat_map; exists d; split; try (apply in_seq; lia);
  apply in_flat_map; exists r; split; try (apply in_seq; lia); simpl; auto.
  right; right. apply in_map_iff. exists c. split; auto. unfold conds. apply filter_In. split; auto. destruct c; simpl; auto.
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

Definition hasb (s : vst) (j : nat) : bool := existsb (fun c => col_eqb c (nth j tg [])) (cols s).

Definition markb (s : vst) : vst :=
  VS (cols s) (flags s) (map (fun j => nth j (dn s) false || hasb s j) (seq 0 n)).

Definition markedb (s : vst) : bool := forallb (fun j => implb (hasb s j) (nth j (dn s) false)) (seq 0 n).

Definition alldoneb (s : vst) : bool := forallb (fun j => nth j (dn s) false) (seq 0 n).

(* ---------- hash table (FMapPositive of buckets); the hash needs no proof ---------- *)
Fixpoint ofn (x : nat) : int := match x with 0 => 0%uint63 | S x' => PrimInt63.add (ofn x') 1%uint63 end.
Definition hstep (h : int) (x : nat) : int := PrimInt63.add (PrimInt63.mul h 31%uint63) (ofn x).
Definition hflag (h : int) (f : comparison) : int := hstep h (fcode f).
Definition hdn (h : int) (b : bool) : int := hstep h (if b then 1 else 0).
Definition hraw (s : vst) : int :=
  fold_left hdn (dn s) (fold_left hflag (flags s)
    (fold_left (fun h c => fold_left hstep c (PrimInt63.mul h 7%uint63)) (cols s) 1%uint63)).
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
  list_eqb col_eqb (cols s) (cols t) && list_eqb cmp_eqb (flags s) (flags t) && list_eqb Bool.eqb (dn s) (dn t).

Lemma vst_eqb_true s t : vst_eqb s t = true -> s = t.
Proof.
  unfold vst_eqb. intros H. apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  apply list_eqb_true in H1; [|intros; apply col_eqb_spec; auto].
  apply list_eqb_true in H2; [|intros x y E; apply fcode_inj, Nat.eqb_eq, E].
  apply list_eqb_true in H3; [|intros x y E; apply Bool.eqb_prop, E].
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

(* ---------- representative instructions ----------
   A register whose column equals the column of a smaller register is not a representative.
   Instructions on non-representative registers are covered by Sound.rinstrs_cover. *)
Definition isrep (s : vst) (r : nat) : bool :=
  forallb (fun r' => negb (col_eqb (getc s r') (getc s r))) (seq 0 r).

Definition rinstrs (s : vst) : list instr :=
  flat_map (fun d => if isrep s d then
     flat_map (fun r => if isrep s r then
        Cmp d r :: (if Nat.eqb d r then [] else Mov d r :: map (fun c => Cmov c d r) conds)
      else []) (seq 0 R) else []) (seq 0 R).

(* ---------- the checker ---------- *)
Definition succ (s : vst) (i : instr) : vst := markb (canon (vstep s i)).

Definition covered (m : tbl) (t : vst) (b : nat) : bool :=
  match tlook m t with Some b' => Nat.leb b b' | None => false end || prune n reps tg strict t b.

Definition check_entry (m : tbl) (e : vst * nat) : bool :=
  let (s, b) := e in
  vwfb s && markedb s && negb (alldoneb s) &&
  match b with 0 => true | S b' => forallb (fun i => covered m (succ s i) b') (rinstrs s) end.

Definition check (V : list (vst * nat)) : bool := let m := build V in forallb (check_entry m) V.

Definition root : vst := markb (canon (vinit n R reps)).

Definition certifies (V : list (vst * nat)) (k : nat) : bool :=
  check V && match tlook (build V) root with Some b => Nat.leb k b | None => false end.

End Check.

(* ---------- untrusted search: layered BFS with the same succ / prune (no proof needed) ---------- *)
Section Search.
Variables (n R : nat) (reps : list (list nat)) (tg : list col) (strict : list nat) (iset : cond -> bool).

Definition expand (b' : nat) (st : list vst * tbl) (s : vst) : list vst * tbl :=
  fold_left (fun (st : list vst * tbl) (i : instr) =>
    let (nx, m) := st in
    let t := succ n tg s i in
    match tlook m t with
    | Some _ => st
    | None => if prune n reps tg strict t b' then st else (t :: nx, tadd m t b')
    end) (rinstrs R iset s) st.

Fixpoint layers (b : nat) (front : list vst) (m : tbl) (acc : list (vst * nat)) : list (vst * nat) :=
  match b with
  | 0 => acc
  | S b' =>
      let (nx, m') := fold_left (expand b') front ([], m) in
      layers b' nx m' (fold_left (fun a t => (t, b') :: a) nx acc)
  end.

Definition search (k : nat) : list (vst * nat) :=
  let r := root n R reps tg in
  layers k [r] (tadd (PositiveMap.empty _) r k) [(r, k)].

End Search.
