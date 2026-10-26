
val implb : bool -> bool -> bool

val negb : bool -> bool

val fst : ('a1 * 'a2) -> 'a1

val snd : ('a1 * 'a2) -> 'a2

val length : 'a1 list -> int

val app : 'a1 list -> 'a1 list -> 'a1 list

type comparison =
| Eq
| Lt
| Gt

val compOpp : comparison -> comparison

type 'a sig0 = 'a
  (* singleton inductive, whose constructor was exist *)



val add : int -> int -> int

val sub : int -> int -> int

val sumbool_of_bool : bool -> bool

val eqb : bool -> bool -> bool

module type TotalLeBool' =
 sig
  type t

  val leb : t -> t -> bool
 end

module Nat :
 sig
  val add : int -> int -> int

  val mul : int -> int -> int

  val ltb : int -> int -> bool

  val compare : int -> int -> comparison

  val pow : int -> int -> int
 end

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val seq : int -> int -> int list

val repeat : 'a1 -> int -> 'a1 list

val nth : int -> 'a1 list -> 'a1 -> 'a1

val remove : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> 'a1 list

val flat_map : ('a1 -> 'a2 list) -> 'a1 list -> 'a2 list

val fold_left : ('a1 -> 'a2 -> 'a1) -> 'a2 list -> 'a1 -> 'a1

val existsb : ('a1 -> bool) -> 'a1 list -> bool

val forallb : ('a1 -> bool) -> 'a1 list -> bool

val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list

type positive =
| XI of positive
| XO of positive
| XH

val lsr0 : Uint63.t -> Uint63.t -> Uint63.t

val land0 : Uint63.t -> Uint63.t -> Uint63.t

val add0 : Uint63.t -> Uint63.t -> Uint63.t

val mul0 : Uint63.t -> Uint63.t -> Uint63.t

val eqb0 : Uint63.t -> Uint63.t -> bool

type cond =
| CL
| CG
| CLE
| CGE

val cond_eval : cond -> comparison -> bool

val cond_inI0 : cond -> bool

val cond_inI1 : cond -> bool

module Sort :
 functor (X:TotalLeBool') ->
 sig
  val merge : X.t list -> X.t list -> X.t list

  val merge_list_to_stack :
    X.t list option list -> X.t list -> X.t list option list

  val merge_stack : X.t list option list -> X.t list

  val iter_merge : X.t list option list -> X.t list -> X.t list

  val sort : X.t list -> X.t list

  val flatten_stack : X.t list option list -> X.t list
 end

module NatOrder :
 sig
  type t = int

  val leb : int -> int -> bool
 end

module NatSort :
 sig
  val merge : int list -> int list -> int list

  val merge_list_to_stack :
    int list option list -> int list -> int list option list

  val merge_stack : int list option list -> int list

  val iter_merge : int list option list -> int list -> int list

  val sort : int list -> int list

  val flatten_stack : int list option list -> int list
 end

type col = int list

val blend : cond -> comparison list -> col -> col -> col

val cmpcol : col -> col -> comparison list

val tgt : int list list -> int -> col

val swapc : cond -> cond

val lexc : int list -> int list -> comparison

val firstne : comparison list -> comparison

val col_eqb : int list -> int list -> bool

val findpos : int -> int -> int list -> int

val idx : int -> int list list -> int -> int -> int

val fcode : comparison -> int

module PositiveMap :
 sig
  type key = positive

  type 'a tree =
  | Leaf
  | Node of 'a tree * 'a option * 'a tree

  type 'a t = 'a tree

  val empty : 'a1 t

  val find : key -> 'a1 t -> 'a1 option

  val add : key -> 'a1 -> 'a1 t -> 'a1 t
 end

val ofn : int -> Uint63.t

val hstep : Uint63.t -> int -> Uint63.t

val hflag : Uint63.t -> comparison -> Uint63.t

val hdn : Uint63.t -> bool -> Uint63.t

val pk : int -> Uint63.t -> positive

type ('c, 'f) sst = { sA : 'c list; sf : 'f; sdn : bool list }

type 'c sop =
| SCmp of 'c * 'c
| SIn of cond * 'c * 'c
| SCopy of cond * 'c * 'c

val memb : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> bool

val addc : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 -> 'a1 list -> 'a1 list

val remc : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> 'a1 list

val smark :
  int -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst -> ('a1,
  'a2) sst

val sstep :
  int -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 -> 'a1) -> ('a1
  -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst -> 'a1 sop -> ('a1,
  'a2) sst

val cost : 'a1 sop -> int

val negS : ('a2 -> 'a2) -> ('a1, 'a2) sst -> ('a1, 'a2) sst

val undone : int -> ('a1, 'a2) sst -> int

val idxS : int -> int list list -> int -> int -> int

val keyS :
  int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> ('a1,
  'a2) sst -> int -> int list

val hcbS :
  int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> int
  list -> ('a1, 'a2) sst -> int -> bool

val deadSb :
  int -> int list list -> ('a1 -> col) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst
  -> bool

val pruneS :
  int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> 'a1 ->
  'a1 list -> int list -> ('a1, 'a2) sst -> int -> bool

val insC : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> 'a1 list

val sortC : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list

val canon1 :
  ('a2 -> 'a2) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) -> ('a1, 'a2)
  sst -> ('a1, 'a2) sst

val rp : int list list -> int list -> col -> col

val rpf : int list list -> int list -> comparison list -> comparison list

val permS :
  (int list -> 'a1 -> 'a1) -> (int list -> 'a2 -> 'a2) -> int list -> ('a1,
  'a2) sst -> ('a1, 'a2) sst

val canonS :
  ('a2 -> 'a2) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) -> (int list ->
  'a1 -> 'a1) -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst
  -> ('a1, 'a2) sst -> bool) -> ('a1, 'a2) sst -> ('a1, 'a2) sst

val condsS : (cond -> bool) -> cond list

val opsS : (cond -> bool) -> 'a1 -> ('a1, 'a2) sst -> 'a1 sop list

val lsteqb : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool

val sst_eqb :
  ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1, 'a2) sst -> ('a1,
  'a2) sst -> bool

type ('c, 'f) sbucket = (('c, 'f) sst * int) list

type ('c, 'f) stbl = ('c, 'f) sbucket PositiveMap.t

val sblook :
  ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1, 'a2) sst -> ('a1,
  'a2) sbucket -> int option

val stlook :
  ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> (('a1, 'a2) sst ->
  positive) -> ('a1, 'a2) stbl -> ('a1, 'a2) sst -> int option

val stadd :
  (('a1, 'a2) sst -> positive) -> ('a1, 'a2) stbl -> ('a1, 'a2) sst -> int ->
  ('a1, 'a2) stbl

val sbuild :
  (('a1, 'a2) sst -> positive) -> (('a1, 'a2) sst * int) list -> ('a1, 'a2)
  stbl

val smarkedb :
  int -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst -> bool

val sdoneb : int -> ('a1, 'a2) sst -> bool

val scovered :
  int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> ('a1 ->
  'a1 -> bool) -> 'a1 -> 'a1 list -> int list -> ('a2 -> 'a2 -> bool) ->
  (('a1, 'a2) sst -> positive) -> ('a1, 'a2) stbl -> ('a1, 'a2) sst -> int ->
  bool

val scheck_entry :
  int -> int list list -> (cond -> bool) -> ('a1 -> col) -> ('a2 ->
  comparison list) -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 ->
  'a1) -> ('a1 -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a2 -> 'a2) -> int list
  -> ('a2 -> 'a2 -> bool) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) ->
  (('a1, 'a2) sst -> positive) -> (int list -> 'a1 -> 'a1) -> (int list ->
  'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst -> ('a1, 'a2) sst -> bool)
  -> ('a1, 'a2) stbl -> (('a1, 'a2) sst * int) -> bool

val scheck :
  int -> int list list -> (cond -> bool) -> ('a1 -> col) -> ('a2 ->
  comparison list) -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 ->
  'a1) -> ('a1 -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a2 -> 'a2) -> int list
  -> ('a2 -> 'a2 -> bool) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) ->
  (('a1, 'a2) sst -> positive) -> (int list -> 'a1 -> 'a1) -> (int list ->
  'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst -> ('a1, 'a2) sst -> bool)
  -> (('a1, 'a2) sst * int) list -> bool

val incol : int list list -> int -> col

val inputsC : int -> int list list -> (col -> 'a1) -> 'a1 list

val root0 :
  int -> int list list -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> (col ->
  'a1) -> (comparison list -> 'a2) -> ('a1, 'a2) sst

val rootS :
  int -> int list list -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> ('a2 ->
  'a2) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) -> (int list -> 'a1 ->
  'a1) -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst ->
  ('a1, 'a2) sst -> bool) -> (col -> 'a1) -> (comparison list -> 'a2) ->
  ('a1, 'a2) sst

val inputs_distinct : int -> int list list -> bool

val scertifies :
  int -> int list list -> (cond -> bool) -> ('a1 -> col) -> ('a2 ->
  comparison list) -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 ->
  'a1) -> ('a1 -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a2 -> 'a2) -> int list
  -> ('a2 -> 'a2 -> bool) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) ->
  (('a1, 'a2) sst -> positive) -> (int list -> 'a1 -> 'a1) -> (int list ->
  'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst -> ('a1, 'a2) sst -> bool)
  -> (col -> 'a1) -> (comparison list -> 'a2) -> (('a1, 'a2) sst * int) list
  -> int -> bool

val nodupb : int list -> bool

val reps_okb : int -> int list list -> bool

val strict_okb : int -> int list list -> int list -> bool

val tg_okb : int -> int list list -> col list -> bool

val tdist_okb : int -> col list -> bool

val sym_okb : (cond -> bool) -> bool

val reps3 : int list list

val strict3 : int list

val tg3 : col list

type lC = int list

type lF = comparison list

val ldec : int list list -> lC -> col

val ldecf : int list list -> lF -> comparison list

val lblend : int list list -> cond -> lF -> lC -> lC -> lC

val lcmp : int list list -> lC -> lC -> lF

val lneg : int list list -> lF -> lF

val lT : int -> int list list -> lC

val lenc : int -> int list list -> int list -> lC

val lencf : int list list -> comparison list -> lF

val lceqb : int list list -> lC -> lC -> bool

val lfeqb : int list list -> lF -> lF -> bool

val lcmpC : int list list -> lC -> lC -> bool

val lfirstne : int list list -> lF -> comparison

val ltgp : int -> int list list -> col list -> lC list

val lhash : int list list -> (lC, lF) sst -> positive

val lpermc : int list list -> int list -> lC -> lC

val lpermf : int list list -> int list -> lF -> lF

val lexl : int list list -> int list list -> comparison

val ltS : int list list -> (lC, lF) sst -> (lC, lF) sst -> bool

val perms_of : int -> int list -> int list list

val index_of : int list -> int list list -> int

val row_perm : int -> int list list -> int list -> int list

val lperms : int -> int list list -> int list list

val pi_okb : int -> int list list -> int list -> bool

val lsstep :
  int -> int list list -> col list -> (lC, lF) sst -> lC sop -> (lC, lF) sst

val lcanon : int -> int list list -> (lC, lF) sst -> (lC, lF) sst

val lops :
  int -> int list list -> (cond -> bool) -> (lC, lF) sst -> lC sop list

val lprune :
  int -> int list list -> col list -> int list -> (lC, lF) sst -> int -> bool

val lroot : int -> int list list -> col list -> (lC, lF) sst

val llook : int list list -> (lC, lF) stbl -> (lC, lF) sst -> int option

val ladd :
  int list list -> (lC, lF) stbl -> (lC, lF) sst -> int -> (lC, lF) stbl

val lcert :
  int -> int list list -> col list -> int list -> (cond -> bool) -> ((lC, lF)
  sst * int) list -> int -> bool

val setb : 'a1 list -> int -> ('a1 -> 'a1) -> 'a1 list

type sstate = ((lC, lF) stbl * (lC, lF) sst list list) * (lC, lF) sst list

val visit :
  int -> int list list -> col list -> int list -> (cond -> bool) -> int ->
  sstate -> (lC, lF) sst -> sstate

val levels :
  int -> int list list -> col list -> int list -> (cond -> bool) -> int ->
  int -> sstate -> sstate

val ssearch :
  int -> int list list -> col list -> int list -> (cond -> bool) -> int ->
  ((lC, lF) sst * int) list

val set_okb :
  int -> int list list -> col list -> int list -> (cond -> bool) -> ((lC, lF)
  sst * int) list -> int -> bool

val iset_of : bool -> cond -> bool

val scert3 : bool -> int -> ((lC, lF) sst * int) list

val sok3 : bool -> int -> ((lC, lF) sst * int) list -> bool
