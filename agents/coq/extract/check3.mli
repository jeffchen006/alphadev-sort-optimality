
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

val add : int -> int -> int

val sub : int -> int -> int

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

val rev : 'a1 list -> 'a1 list

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

type instr =
| Mov of int * int
| Cmp of int * int
| Cmov of cond * int * int

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

type vst = { cols : col list; flags : comparison list; dn : bool list }

val setn : 'a1 list -> int -> 'a1 -> 'a1 list

val blend : cond -> comparison list -> col -> col -> col

val cmpcol : col -> col -> comparison list

val getc : vst -> int -> col

val vstep : vst -> instr -> vst

val vinit : int -> int -> int list list -> vst

val tgt : int list list -> int -> col

val swapc : cond -> cond

val swapregs : int -> int -> vst -> vst

val negflags : vst -> vst

val lexc : int list -> int list -> comparison

val cswap : vst -> int -> vst

val fpass : int -> vst -> vst

val bpass : int -> vst -> vst

val firstne : comparison list -> comparison

val normflags : vst -> vst

val canon : int -> vst -> vst

val col_eqb : int list -> int list -> bool

val deadb : int -> int list list -> col list -> vst -> bool

val hw : int -> vst -> int

val findpos : int -> int -> int list -> int

val idx : int -> int list list -> int -> int -> int

val fcode : comparison -> int

val key : int -> int list list -> vst -> int -> int list

val hcb : int -> int list list -> int list -> vst -> int -> bool

val prune : int -> int list list -> col list -> int list -> vst -> int -> bool

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

val conds : (cond -> bool) -> cond list

val vwfb : int -> int list list -> vst -> bool

val hasb : col list -> vst -> int -> bool

val markb : int -> col list -> vst -> vst

val markedb : int -> col list -> vst -> bool

val alldoneb : int -> vst -> bool

val ofn : int -> Uint63.t

val hstep : Uint63.t -> int -> Uint63.t

val hflag : Uint63.t -> comparison -> Uint63.t

val hdn : Uint63.t -> bool -> Uint63.t

val hraw : vst -> Uint63.t

val pk : int -> Uint63.t -> positive

val hkey : vst -> positive

val list_eqb : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool

val cmp_eqb : comparison -> comparison -> bool

val vst_eqb : vst -> vst -> bool

type bucket = (vst * int) list

type tbl = bucket PositiveMap.t

val blook : vst -> bucket -> int option

val tlookh : (vst -> positive) -> tbl -> vst -> int option

val taddh : (vst -> positive) -> tbl -> vst -> int -> tbl

val buildh : (vst -> positive) -> (vst * int) list -> tbl

val tlook : tbl -> vst -> int option

val tadd : tbl -> vst -> int -> tbl

val build : (vst * int) list -> tbl

val isrep : vst -> int -> bool

val rinstrs : int -> (cond -> bool) -> vst -> instr list

val succ : int -> int -> col list -> vst -> instr -> vst

val covered :
  int -> int list list -> col list -> int list -> tbl -> vst -> int -> bool

val check_entry :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  tbl -> (vst * int) -> bool

val check :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  (vst * int) list -> bool

val root : int -> int -> int list list -> col list -> vst

val certifies :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  (vst * int) list -> int -> bool

val expand :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  int -> (vst list * tbl) -> vst -> vst list * tbl

val layers :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  int -> vst list -> tbl -> (vst * int) list -> (vst * int) list

val search :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  int -> (vst * int) list

val nodupb : int list -> bool

val reps_okb : int -> int list list -> bool

val strict_okb : int -> int list list -> int list -> bool

val tg_okb : int -> int list list -> col list -> bool

val tdist_okb : int -> col list -> bool

val sym_okb : (cond -> bool) -> bool

val all_okb :
  int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
  (vst * int) list -> int -> bool

val reps3 : int list list

val strict3 : int list

val tg3 : col list

val iset_of : bool -> cond -> bool

val cert3 : bool -> int -> (vst * int) list

val okb3 : bool -> int -> (vst * int) list -> bool
