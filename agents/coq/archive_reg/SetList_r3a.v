(* SetList.v -- list instance of the abstract set model (columns = lists of length W), untrusted search,
   and the instantiated end theorem lower_bound_set (registers unbounded: any R >= n). *)
From Stdlib Require Import List Bool Lia Arith PArith Eqdep_dec FMapPositive Mergesort.
From Stdlib Require Import PrimInt63 Uint63.
From CmovSort Require Import Machine Vec Good Prune Check SetModel Inst.
Import ListNotations.

Arguments sA {C F}. Arguments sf {C F}. Arguments sdn {C F}. Arguments SS {C F}.
Arguments cost {C}.

Section SetList.
Variables (n : nat) (reps : list (list nat)) (tg : list col) (strict : list nat) (iset : cond -> bool).
Let W := length reps.

Definition LC := {l : list nat | Nat.eqb (length l) W = true}.
Definition LF := {l : list comparison | Nat.eqb (length l) W = true}.
Definition ldec (a : LC) : col := proj1_sig a.
Definition ldecf (f : LF) : list comparison := proj1_sig f.

Lemma sig_ext {A} (a b : {l : list A | Nat.eqb (length l) W = true}) : proj1_sig a = proj1_sig b -> a = b.
Proof. destruct a as [x Hx], b as [y Hy]; simpl; intros ->. f_equal. apply UIP_dec, bool_dec. Qed.

Lemma lenW {A} (a : {l : list A | Nat.eqb (length l) W = true}) : length (proj1_sig a) = W.
Proof. destruct a as [x Hx]. simpl. apply Nat.eqb_eq, Hx. Qed.

Lemma blend_ok c (f : LF) (a b : LC) : Nat.eqb (length (blend c (ldecf f) (ldec a) (ldec b))) W = true.
Proof. apply Nat.eqb_eq, blend_len; apply lenW. Qed.
Definition lblend c (f : LF) (a b : LC) : LC := exist _ _ (blend_ok c f a b).

Lemma cmp_ok (a b : LC) : Nat.eqb (length (cmpcol (ldec a) (ldec b))) W = true.
Proof. apply Nat.eqb_eq, cmpcol_len; apply lenW. Qed.
Definition lcmp (a b : LC) : LF := exist _ _ (cmp_ok a b).

Lemma neg_ok (f : LF) : Nat.eqb (length (map CompOpp (ldecf f))) W = true.
Proof. apply Nat.eqb_eq. rewrite length_map. apply lenW. Qed.
Definition lneg (f : LF) : LF := exist _ _ (neg_ok f).

Lemma T_ok : Nat.eqb (length (repeat n W)) W = true.
Proof. apply Nat.eqb_eq, repeat_length. Qed.
Definition lT : LC := exist _ _ T_ok.

Definition lenc (l : list nat) : LC :=
  match Sumbool.sumbool_of_bool (Nat.eqb (length l) W) with left H => exist _ l H | right _ => lT end.

Lemma F0_ok : Nat.eqb (length (repeat Eq W)) W = true.
Proof. apply Nat.eqb_eq, repeat_length. Qed.

Definition lencf (l : list comparison) : LF :=
  match Sumbool.sumbool_of_bool (Nat.eqb (length l) W) with left H => exist _ l H | right _ => exist _ _ F0_ok end.

Definition lceqb (a b : LC) : bool := col_eqb (ldec a) (ldec b).
Definition lfeqb (f g : LF) : bool := lsteqb (fun x y => Nat.eqb (fcode x) (fcode y)) (ldecf f) (ldecf g).
Definition lcmpC (a b : LC) : bool := match lexc (ldec a) (ldec b) with Gt => false | _ => true end.
Definition lfirstne (f : LF) : comparison := firstne (ldecf f).
Definition ltgp : list LC := map lenc tg.

Definition lhash (t : sst LC LF) : positive :=
  pk 22 (PrimInt63.lsr (PrimInt63.mul
    (fold_left hdn (sdn t) (fold_left hflag (ldecf (sf t))
      (fold_left (fun h c => fold_left hstep (ldec c) (PrimInt63.mul h 7%uint63)) (sA t) 1%uint63)))
    5871781006564002453%uint63) 40%uint63).

Lemma rp_ok pi (a : LC) : Nat.eqb (length (rp reps pi (ldec a))) W = true.
Proof. apply Nat.eqb_eq, rp_len. Qed.
Definition lpermc (pi : list nat) (a : LC) : LC := exist _ _ (rp_ok pi a).
Lemma rpf_ok pi (f : LF) : Nat.eqb (length (rpf reps pi (ldecf f))) W = true.
Proof. apply Nat.eqb_eq, rpf_len. Qed.
Definition lpermf (pi : list nat) (f : LF) : LF := exist _ _ (rpf_ok pi f).

Fixpoint lexl (a b : list (list nat)) : comparison :=
  match a, b with
  | [], [] => Eq | [], _ => Lt | _, [] => Gt
  | x :: a', y :: b' => match lexc x y with Eq => lexl a' b' | c => c end
  end.
Definition ltS (t u : sst LC LF) : bool :=
  match lexl (map ldec (sA t)) (map ldec (sA u)) with
  | Lt => true | Gt => false
  | Eq => match lexc (map fcode (ldecf (sf t))) (map fcode (ldecf (sf u))) with Lt => true | _ => false end
  end.

(* candidate row permutations: for each relabelling sigma of the inputs, w -> index of rep_w o sigma *)
Fixpoint perms_of (fuel : nat) (l : list nat) : list (list nat) :=
  match fuel, l with
  | _, [] => [[]]
  | 0, _ => []
  | S f, _ => flat_map (fun x => map (cons x) (perms_of f (remove Nat.eq_dec x l))) l
  end.
Fixpoint index_of (x : list nat) (l : list (list nat)) : nat :=
  match l with [] => 0 | y :: l' => if col_eqb x y then 0 else S (index_of x l') end.
Definition row_perm (sigma : list nat) : list nat :=
  map (fun w => index_of (map (fun i => nth (nth i sigma 0) (nth w reps []) 0) (seq 0 n)) reps) (seq 0 W).
Definition lperms : list (list nat) := map row_perm (perms_of n (seq 0 n)).

Definition pi_okb (pi : list nat) : bool :=
  forallb (fun w => Nat.ltb (nth w pi 0) W) (seq 0 W) &&
  forallb (fun v => existsb (fun w => Nat.eqb (nth w pi 0) v) (seq 0 W)) (seq 0 W) &&
  forallb (fun j => col_eqb (rp reps pi (tgt reps j)) (tgt reps j)) (seq 0 n).

Lemma pi_okb_spec pi : pi_okb pi = true -> pi_ok reps pi /\ (forall j, j < n -> rp reps pi (tgt reps j) = tgt reps j).
Proof.
  unfold pi_okb. intros H. apply andb_true_iff in H as [H H3]. apply andb_true_iff in H as [H1 H2].
  rewrite forallb_forall in H1, H2, H3. split; [split|].
  - intros w Hw. apply Nat.ltb_lt, H1, in_seq. lia.
  - intros v Hv. specialize (H2 v ltac:(apply in_seq; lia)). apply existsb_exists in H2 as [w [Hw E]].
    apply in_seq in Hw. exists w. split; [lia|]. apply Nat.eqb_eq, E.
  - intros j Hj. apply col_eqb_spec, H3, in_seq. lia.
Qed.

(* the instantiated functions *)
Definition Lsstep := sstep n LC LF lceqb lblend lcmp lT ltgp.
Definition Lcanon := canonS LC LF lneg lcmpC lfirstne lpermc lpermf lperms ltS.
Definition Lops := opsS iset LC LF lT.
Definition Lprune := pruneS n reps LC LF ldec ldecf lceqb lT ltgp strict.
Definition Lroot := rootS n reps LC LF lceqb lT ltgp lneg lcmpC lfirstne lpermc lpermf lperms ltS lenc lencf.
Definition Llook := stlook LC LF lceqb lfeqb lhash.
Definition Ladd := stadd LC LF lhash.
Definition Ldom := domb n LC LF lceqb lfeqb.
Definition Lbuild := sbuild LC LF lhash.
Definition Lmark := smark n LC LF lceqb lT ltgp.
Definition Lmarkedb := smarkedb n LC LF lceqb lT ltgp.
Definition Lentry := scheck_entry n reps iset LC LF ldec ldecf lceqb lblend lcmp lT ltgp lneg strict lfeqb lcmpC lfirstne
                      lhash lpermc lpermf lperms ltS.
Definition Lcert := scertifies n reps iset LC LF ldec ldecf lceqb lblend lcmp lT ltgp lneg strict lfeqb lcmpC lfirstne
                      lhash lpermc lpermf lperms ltS lenc lencf.

(* ---------- untrusted search: buckets by budget, best budget kept in the table ---------- *)
Fixpoint setb {A} (l : list A) (i : nat) (f : A -> A) : list A :=
  match l, i with [], _ => [] | x :: t, 0 => f x :: t | x :: t, S i' => x :: setb t i' f end.

Definition sstate := (stbl LC LF * list (list (sst LC LF)) * list (sst LC LF))%type.

Definition visit (b : nat) (st : sstate) (t : sst LC LF) : sstate :=
  match Llook (fst (fst st)) t with
  | Some bt => if Nat.eqb bt b then
      fold_left (fun (st : sstate) o =>
        if Nat.leb (cost o) b && negb (Ldom (Lsstep t o) t) then
          let u := Lcanon (Lsstep t o) in
          let b' := b - cost o in
          let '(m, bk, all) := st in
          if Lprune u b' then st else
          match Llook m u with
          | Some bu => if Nat.ltb bu b' then (Ladd m u b', setb bk b' (cons u), all) else st
          | None => (Ladd m u b', setb bk b' (cons u), u :: all)
          end
        else st) (Lops t) st
     else st
  | None => st
  end.

Fixpoint levels (fuel b : nat) (st : sstate) : sstate :=
  match fuel with
  | 0 => st
  | S f => let st' := fold_left (visit b) (nth b (snd (fst st)) []) st in
           match b with 0 => st' | S b' => levels f b' st' end
  end.

Definition ssearch (k : nat) : list (sst LC LF * nat) :=
  let r := Lroot in
  let m0 := Ladd (PositiveMap.empty _) r k in
  let bk0 := setb (repeat [] (S k)) k (cons r) in
  let '(m, _, all) := levels (S k) k (m0, bk0, [r]) in
  map (fun t => (t, match Llook m t with Some b => b | None => 0 end)) all.

(* ---------- the instance satisfies the interface ---------- *)
Lemma lenc_spec l : length l = W -> ldec (lenc l) = l.
Proof.
  intros H. unfold lenc. destruct (Sumbool.sumbool_of_bool _) as [E|E]; [reflexivity|].
  apply Nat.eqb_neq in E. contradiction.
Qed.

Lemma lencf_spec l : length l = W -> ldecf (lencf l) = l.
Proof.
  intros H. unfold lencf. destruct (Sumbool.sumbool_of_bool _) as [E|E]; [reflexivity|].
  apply Nat.eqb_neq in E. contradiction.
Qed.

Lemma lceqb_spec a b : lceqb a b = true <-> a = b.
Proof. unfold lceqb. rewrite col_eqb_spec. split; [apply sig_ext|intros ->; reflexivity]. Qed.

Lemma lfeqb_spec f g : lfeqb f g = true -> f = g.
Proof.
  unfold lfeqb. intros H. apply sig_ext. apply (lsteqb_true (fun x y => Nat.eqb (fcode x) (fcode y))); [|exact H].
  intros x y E. apply fcode_inj, Nat.eqb_eq, E.
Qed.

Theorem lower_bound_set V k :
  0 < W -> reps_okb n reps = true -> tg_okb n reps tg = true -> tdist_okb n tg = true ->
  strict_okb n reps strict = true -> sym_okb iset = true -> 1 <= n -> forallb pi_okb lperms = true ->
  Lcert V k = true ->
  forall R, n <= R -> forall p o, length p <= k -> prog_ok iset R p -> ~ RelaxedSnap n p o.
Proof.
  intros HW Hr Ht Hd Hs Hy Hn HP HC R HnR.
  apply reps_okb_spec in Hr. pose proof (tg_okb_spec _ _ _ Ht) as Htg.
  destruct (strict_okb_spec _ _ _ Hs) as [S1 [S2 S3]].
  refine (scertifies_sound n R reps iset HW Hr LC LF ldec ldecf sig_ext lenW lenW lceqb lceqb_spec
           lblend _ lcmp _ lT _ ltgp _ _ _ _ lneg _ strict S1 S2 S3 lfeqb lfeqb_spec lcmpC lfirstne lhash
           lpermc _ lpermf _ lperms _ ltS lenc _ lencf lencf_spec Hn HnR V k HC).
  - intros; reflexivity.
  - intros; reflexivity.
  - reflexivity.
  - intros j Hj. unfold ltgp.
    assert (Lt : j < length tg).
    { destruct (Nat.lt_ge_cases j (length tg)) as [|G]; auto. exfalso. specialize (Htg j Hj).
      rewrite nth_overflow in Htg by auto. assert (length (tgt reps j) = W) by (unfold tgt; now rewrite length_map).
      rewrite <- Htg in H. simpl in H. lia. }
    rewrite (nth_map_lt _ _ _ _ []) by auto. rewrite Htg by auto. apply lenc_spec. unfold tgt. now rewrite length_map.
  - intros f g E. apply sig_ext, E.
  - apply (tdist_okb_spec _ _ _ Ht Hd).
  - apply (sym_okb_spec _ Hy).
  - intros f. reflexivity.
  - intros pi a. reflexivity.
  - intros pi f. reflexivity.
  - intros pi Hpi. apply pi_okb_spec. rewrite forallb_forall in HP. auto.
  - intros l Hl _. apply lenc_spec, Hl.
Qed.

Definition set_okb V k : bool :=
  Nat.ltb 0 W && reps_okb n reps && tg_okb n reps tg && tdist_okb n tg && strict_okb n reps strict
  && sym_okb iset && Nat.leb 1 n && forallb pi_okb lperms && Lcert V k.

Corollary lower_bound_set' V k : set_okb V k = true ->
  forall R, n <= R -> forall p o, length p <= k -> prog_ok iset R p -> ~ RelaxedSnap n p o.
Proof.
  unfold set_okb. intros H. repeat (apply andb_true_iff in H as [H ?]).
  apply Nat.ltb_lt in H. apply Nat.leb_le in H2.
  apply (lower_bound_set V k H H7 H6 H5 H4 H3 H2 H1 H0).
Qed.

End SetList.
