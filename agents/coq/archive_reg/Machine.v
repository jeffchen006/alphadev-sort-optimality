(* Machine.v -- the cmov machine of shared/MODEL.md, section 1 and 2.
   Mirrors agents/lean/SortProof/Machine.lean clause by clause (see agents/coq/NOTES.md, "Semantics diff").
   Registers are indexed by nat: register i < n is P i, register n + j is S j.
   The register budget R is a well-formedness bound (prog_wf R), not part of the state.
   Values have any type A; the machine reads values only through a compare function ord.
   The flag state is one comparison (Lt / Eq / Gt). *)
From Stdlib Require Import ZArith List Bool Sorted Permutation Lia.
Import ListNotations.

(* Condition codes of cmov: l, g (I0) and le, ge (I1). *)
Inductive cond := CL | CG | CLE | CGE.

Inductive instr :=
| Mov (d s : nat)
| Cmp (a b : nat)
| Cmov (c : cond) (d s : nat).

Definition program := list instr.

Definition cond_eval (c : cond) (o : comparison) : bool :=
  match c, o with
  | CL, Lt => true
  | CG, Gt => true
  | CLE, Gt => false
  | CLE, _ => true
  | CGE, Lt => false
  | CGE, _ => true
  | _, _ => false
  end.

(* Instruction set I0 = mov, cmp, cmovl, cmovg. *)
Definition cond_inI0 (c : cond) : bool :=
  match c with CL | CG => true | _ => false end.

Definition instr_in (iset : cond -> bool) (i : instr) : bool :=
  match i with Cmov c _ _ => iset c | _ => true end.

Definition instr_regs (i : instr) : list nat :=
  match i with Mov d s => [d; s] | Cmp a b => [a; b] | Cmov _ d s => [d; s] end.

(* All registers of the program are < R. *)
Definition prog_wf (R : nat) (p : program) : Prop :=
  forall i, In i p -> forall r, In r (instr_regs i) -> r < R.

Record state (A : Type) := mkState { regs : nat -> A; flag : comparison }.
Arguments mkState {A}. Arguments regs {A}. Arguments flag {A}.

Definition upd {A} (f : nat -> A) (d : nat) (v : A) : nat -> A :=
  fun r => if Nat.eqb r d then v else f r.

Definition step {A} (ord : A -> A -> comparison) (s : state A) (i : instr) : state A :=
  match i with
  | Mov d src => mkState (upd (regs s) d (regs s src)) (flag s)
  | Cmp a b => mkState (regs s) (ord (regs s a) (regs s b))
  | Cmov c d src =>
      if cond_eval c (flag s) then mkState (upd (regs s) d (regs s src)) (flag s) else s
  end.

Definition run {A} (ord : A -> A -> comparison) (p : program) (s : state A) : state A :=
  fold_left (step ord) p s.

(* Sorting specification: the outputs P0..P{n-1} are sorted (<=) and a permutation of the inputs.
   (Lean: equal to List.mergeSort of the inputs; equivalent, see Spec lemma sorted_perm_unique.) *)
Definition outs (n : nat) (y : nat -> Z) : list Z := map y (seq 0 n).

Definition SortsOK (n : nat) (x y : nat -> Z) : Prop :=
  Sorted Z.le (outs n y) /\ Permutation (outs n x) (outs n y).

(* Strict model: correct for every initial state (inputs, garbage scratch values, flags). *)
Definition StrictCorrect (n : nat) (p : program) : Prop :=
  forall s : state Z, SortsOK n (regs s) (regs (run Z.compare p s)).

(* Relaxed model (MODEL.md section 2): P i = x i, every scratch register = T, flags = eq. *)
Definition relaxInit (n : nat) (x : nat -> Z) (T : Z) : state Z :=
  mkState (fun r => if Nat.ltb r n then x r else T) Eq.

Definition RelaxedCorrect (n : nat) (p : program) : Prop :=
  forall (x : nat -> Z) (T : Z), (forall i, i < n -> (x i < T)%Z) ->
    SortsOK n x (regs (run Z.compare p (relaxInit n x T))).

Lemma strict_relaxed : forall n p, StrictCorrect n p -> RelaxedCorrect n p.
Proof.
  intros n p H x T _. specialize (H (relaxInit n x T)).
  unfold SortsOK, outs in *. simpl in H.
  replace (map (fun r => if Nat.ltb r n then x r else T) (seq 0 n)) with (map x (seq 0 n)) in H; [exact H|].
  apply map_ext_in. intros a Ha. apply in_seq in Ha.
  destruct (Nat.ltb_spec a n); [reflexivity | lia].
Qed.
