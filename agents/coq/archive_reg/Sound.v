(* Sound.v -- soundness of the certificate checker of Check.v (main theorem: certifies_sound). *)
From Stdlib Require Import List Bool Lia Arith ZArith PArith FMapPositive Mergesort.
From CmovSort Require Import Machine Vec Good Prune Check.
Import ListNotations.

Section Sound.
Variables (n R : nat) (reps : list (list nat)) (tg : list col) (strict : list nat).
Let W := length reps.
Hypothesis HnR : n <= R.
Hypothesis Hreps : reps_ok n reps.
Hypothesis Htg : forall j, j < n -> nth j tg [] = tgt reps j.
Hypothesis Hstrict : forall w, In w strict ->
  w < W /\ NoDup (nth w reps []) /\ NatSort.sort (nth w reps []) = seq 0 n.
Hypothesis Hsdist : forall w1 w2, In w1 strict -> In w2 strict -> nth w1 reps [] = nth w2 reps [] -> w1 = w2.
Hypothesis HsND : NoDup strict.

Lemma check_entry_inv m s b : check_entry n R reps tg strict m (s, b) = true ->
  vwfb R reps s = true /\ goalb n tg s = false /\
  (forall b'', b = S b'' -> forall i, In i (instrs R) -> covered n R reps tg strict m (canon n R (vstep s i)) b'' = true).
Proof.
  unfold check_entry. intros H. apply andb_true_iff in H as [H HS]. apply andb_true_iff in H as [HW HG].
  apply negb_true_iff in HG. split; auto. split; auto.
  intros b'' -> i Hi. rewrite forallb_forall in HS. auto.
Qed.

Lemma covered_sound V t b b'' :
  (forall s' b3, In (s', b3) V -> b <= b3 -> ~ vgood n R reps s' b) ->
  vwf R W t -> vgood n R reps t b -> b <= b'' ->
  covered n R reps tg strict (build V) t b'' = true -> False.
Proof.
  intros IH Hcw Hc Hle HS.
  unfold covered in HS. apply orb_true_iff in HS as [HS|HS].
  - destruct (tlook (build V) t) as [b3|] eqn:F; [|discriminate].
    apply Nat.leb_le in HS. apply tlook_build in F.
    apply (IH _ b3 F); [lia|auto].
  - apply (prune_sound n R reps HnR Hreps tg Htg strict Hstrict Hsdist HsND t b'' Hcw HS).
    apply vgood_mono with b; [lia|auto].
Qed.

Theorem check_sound V : check n R reps tg strict V = true ->
  forall b s b', In (s, b') V -> b <= b' -> ~ vgood n R reps s b.
Proof.
  unfold check. intros HC. rewrite forallb_forall in HC.
  induction b as [|b IH]; intros s b' Hin Hle Hg;
    destruct (check_entry_inv _ s b' (HC _ Hin)) as [HW [HG HS]]; apply vwfb_spec in HW.
  - destruct (vgood_inv n R reps s 0 Hg) as [G|[i [b0 [E _]]]]; [|discriminate].
    rewrite (goalb_spec n R reps tg) in HG by auto. discriminate.
  - destruct (vgood_inv n R reps s (S b) Hg) as [G|[i [b0 [E [Hi [Hi0 Hgi]]]]]].
    { rewrite (goalb_spec n R reps tg) in HG by auto. discriminate. }
    injection E as E. subst b0.
    destruct b' as [|b'']; [lia|].
    pose proof (vwf_step R W s i HW Hi) as Ht.
    destruct (canon_good n R reps (vstep s i) b Ht HnR Hgi) as [Hc Hcw].
    apply (covered_sound V (canon n R (vstep s i)) b b'' IH Hcw Hc); [lia|].
    apply HS; auto. apply (instrs_complete n R reps HnR); auto.
Qed.


Definition certifies (V : list (vst * nat)) (k : nat) : bool :=
  check n R reps tg strict V && match tlook (build V) (root n R reps) with Some b => Nat.leb k b | None => false end.

Theorem certifies_sound V k : certifies V k = true ->
  forall p, length p <= k -> prog_ok R p -> ~ RelaxedCorrect n p.
Proof.
  unfold certifies. intros H p Hl Hok Hc. apply andb_true_iff in H as [H1 H2].
  destruct (tlook (build V) (root n R reps)) as [b|] eqn:F; [|discriminate].
  apply Nat.leb_le in H2. apply tlook_build in F.
  assert (Hg : vgood n R reps (vinit n R reps) k).
  { exists p. split; auto. split; auto. apply relaxed_vgoal; auto. intros i Hi; apply Hok; auto. }
  destruct (canon_good n R reps (vinit n R reps) k (vwf_init n R reps) HnR Hg) as [Hg' _].
  apply (check_sound V H1 k (root n R reps) b F H2 Hg').
Qed.

End Sound.


(* ---------- untrusted search: layered BFS with the same canon / prune (no proof needed) ---------- *)
Section Search.
Variables (n R : nat) (reps : list (list nat)) (tg : list col) (strict : list nat).

Definition expand (b' : nat) (st : list vst * tbl) (s : vst) : list vst * tbl :=
  fold_left (fun (st : list vst * tbl) (i : instr) =>
    let (nx, m) := st in
    let t := canon n R (vstep s i) in
    match tlook m t with
    | Some _ => st
    | None => if prune n R reps tg strict t b' then st else (t :: nx, tadd m t b')
    end) (instrs R) st.

Fixpoint layers (b : nat) (front : list vst) (m : tbl) (acc : list (vst * nat)) : list (vst * nat) :=
  match b with
  | 0 => acc
  | S b' =>
      let (nx, m') := fold_left (expand b') front ([], m) in
      layers b' nx m' (fold_left (fun a t => (t, b') :: a) nx acc)
  end.

Definition search (k : nat) : list (vst * nat) :=
  let r := root n R reps in
  layers k [r] (tadd (PositiveMap.empty _) r k) [(r, k)].

End Search.
