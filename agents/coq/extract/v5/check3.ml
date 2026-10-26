
(** val implb : bool -> bool -> bool **)

let implb b1 b2 =
  if b1 then b2 else true

(** val negb : bool -> bool **)

let negb = function
| true -> false
| false -> true

(** val fst : ('a1 * 'a2) -> 'a1 **)

let fst = function
| (x, _) -> x

(** val snd : ('a1 * 'a2) -> 'a2 **)

let snd = function
| (_, y) -> y

(** val length : 'a1 list -> int **)

let rec length = function
| [] -> 0
| _ :: l' -> Stdlib.Int.succ (length l')

(** val app : 'a1 list -> 'a1 list -> 'a1 list **)

let rec app l m =
  match l with
  | [] -> m
  | a :: l1 -> a :: (app l1 m)

type comparison =
| Eq
| Lt
| Gt

(** val compOpp : comparison -> comparison **)

let compOpp = function
| Eq -> Eq
| Lt -> Gt
| Gt -> Lt

(** val add : int -> int -> int **)

let rec add = (+)

(** val sub : int -> int -> int **)

let rec sub = fun n m -> Stdlib.max 0 (n-m)

(** val eqb : bool -> bool -> bool **)

let eqb b1 b2 =
  if b1 then b2 else if b2 then false else true

module type TotalLeBool' =
 sig
  type t

  val leb : t -> t -> bool
 end

module Nat =
 struct
  (** val add : int -> int -> int **)

  let rec add n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> m)
      (fun p -> Stdlib.Int.succ (add p m))
      n

  (** val mul : int -> int -> int **)

  let rec mul n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> 0)
      (fun p -> add m (mul p m))
      n

  (** val sub : int -> int -> int **)

  let rec sub n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> n)
      (fun k ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> n)
        (fun l -> sub k l)
        m)
      n

  (** val ltb : int -> int -> bool **)

  let ltb n m =
    (<=) (Stdlib.Int.succ n) m

  (** val compare : int -> int -> comparison **)

  let rec compare = fun n m -> if n=m then Eq else if n<m then Lt else Gt

  (** val pow : int -> int -> int **)

  let rec pow n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> Stdlib.Int.succ 0)
      (fun m0 -> mul n (pow n m0))
      m

  (** val divmod : int -> int -> int -> int -> int * int **)

  let rec divmod x y q u =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> (q, u))
      (fun x' ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> divmod x' y (Stdlib.Int.succ q) y)
        (fun u' -> divmod x' y q u')
        u)
      x

  (** val modulo : int -> int -> int **)

  let modulo x y =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> x)
      (fun y' -> sub y' (snd (divmod x y' 0 y')))
      y
 end

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| a :: l0 -> (f a) :: (map f l0)

(** val seq : int -> int -> int list **)

let rec seq start len =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> [])
    (fun len0 -> start :: (seq (Stdlib.Int.succ start) len0))
    len

(** val repeat : 'a1 -> int -> 'a1 list **)

let rec repeat x n =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> [])
    (fun k -> x :: (repeat x k))
    n

(** val nth : int -> 'a1 list -> 'a1 -> 'a1 **)

let rec nth n l default =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> match l with
              | [] -> default
              | x :: _ -> x)
    (fun m -> match l with
              | [] -> default
              | _ :: l' -> nth m l' default)
    n

(** val rev_append : 'a1 list -> 'a1 list -> 'a1 list **)

let rec rev_append l l' =
  match l with
  | [] -> l'
  | a :: l0 -> rev_append l0 (a :: l')

(** val flat_map : ('a1 -> 'a2 list) -> 'a1 list -> 'a2 list **)

let rec flat_map f = function
| [] -> []
| x :: l0 -> app (f x) (flat_map f l0)

(** val fold_left : ('a1 -> 'a2 -> 'a1) -> 'a2 list -> 'a1 -> 'a1 **)

let rec fold_left f l a0 =
  match l with
  | [] -> a0
  | b :: l0 -> fold_left f l0 (f a0 b)

(** val existsb : ('a1 -> bool) -> 'a1 list -> bool **)

let rec existsb f = function
| [] -> false
| a :: l0 -> (||) (f a) (existsb f l0)

(** val forallb : ('a1 -> bool) -> 'a1 list -> bool **)

let rec forallb f = function
| [] -> true
| a :: l0 -> (&&) (f a) (forallb f l0)

(** val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list **)

let rec filter f = function
| [] -> []
| x :: l0 -> if f x then x :: (filter f l0) else filter f l0

type positive =
| XI of positive
| XO of positive
| XH

(** val lsr0 : Uint63.t -> Uint63.t -> Uint63.t **)

let lsr0 = Uint63.l_sr

(** val land0 : Uint63.t -> Uint63.t -> Uint63.t **)

let land0 = Uint63.l_and

(** val add0 : Uint63.t -> Uint63.t -> Uint63.t **)

let add0 = Uint63.add

(** val mul0 : Uint63.t -> Uint63.t -> Uint63.t **)

let mul0 = Uint63.mul

(** val eqb0 : Uint63.t -> Uint63.t -> bool **)

let eqb0 = Uint63.equal

type cond =
| CL
| CG
| CLE
| CGE

type instr =
| Mov of int * int
| Cmp of int * int
| Cmov of cond * int * int

(** val cond_eval : cond -> comparison -> bool **)

let cond_eval c o =
  match c with
  | CL -> (match o with
           | Lt -> true
           | _ -> false)
  | CG -> (match o with
           | Gt -> true
           | _ -> false)
  | CLE -> (match o with
            | Gt -> false
            | _ -> true)
  | CGE -> (match o with
            | Lt -> false
            | _ -> true)

(** val cond_inI0 : cond -> bool **)

let cond_inI0 = function
| CL -> true
| CG -> true
| _ -> false

(** val cond_inI1 : cond -> bool **)

let cond_inI1 _ =
  true

module Sort =
 functor (X:TotalLeBool') ->
 struct
  (** val merge : X.t list -> X.t list -> X.t list **)

  let rec merge l1 l2 =
    let rec merge_aux l3 =
      match l1 with
      | [] -> l3
      | a1 :: l1' ->
        (match l3 with
         | [] -> l1
         | a2 :: l2' ->
           if X.leb a1 a2 then a1 :: (merge l1' l3) else a2 :: (merge_aux l2'))
    in merge_aux l2

  (** val merge_list_to_stack :
      X.t list option list -> X.t list -> X.t list option list **)

  let rec merge_list_to_stack stack l =
    match stack with
    | [] -> (Some l) :: []
    | y :: stack' ->
      (match y with
       | Some l' -> None :: (merge_list_to_stack stack' (merge l' l))
       | None -> (Some l) :: stack')

  (** val merge_stack : X.t list option list -> X.t list **)

  let rec merge_stack = function
  | [] -> []
  | y :: stack' ->
    (match y with
     | Some l -> merge l (merge_stack stack')
     | None -> merge_stack stack')

  (** val iter_merge : X.t list option list -> X.t list -> X.t list **)

  let rec iter_merge stack = function
  | [] -> merge_stack stack
  | a :: l' -> iter_merge (merge_list_to_stack stack (a :: [])) l'

  (** val sort : X.t list -> X.t list **)

  let sort =
    iter_merge []

  (** val flatten_stack : X.t list option list -> X.t list **)

  let rec flatten_stack = function
  | [] -> []
  | o :: stack' ->
    (match o with
     | Some l -> app l (flatten_stack stack')
     | None -> flatten_stack stack')
 end

module NatOrder =
 struct
  type t = int

  (** val leb : int -> int -> bool **)

  let rec leb x y =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> true)
      (fun x' ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> false)
        (fun y' -> leb x' y')
        y)
      x
 end

module NatSort = Sort(NatOrder)

type col = int list

type vst = { cols : col list; flags : comparison list; dn : bool list }

(** val setn : 'a1 list -> int -> 'a1 -> 'a1 list **)

let rec setn l i v =
  match l with
  | [] -> []
  | h :: t0 ->
    ((fun fO fS n -> if n=0 then fO () else fS (n-1))
       (fun _ -> v :: t0)
       (fun i' -> h :: (setn t0 i' v))
       i)

(** val blend : cond -> comparison list -> col -> col -> col **)

let rec blend c fl xd xs =
  match fl with
  | [] -> []
  | f :: fl' ->
    (match xd with
     | [] -> []
     | a :: xd' ->
       (match xs with
        | [] -> []
        | b :: xs' ->
          (if cond_eval c f then b else a) :: (blend c fl' xd' xs')))

(** val cmpcol : col -> col -> comparison list **)

let rec cmpcol xa xb =
  match xa with
  | [] -> []
  | a :: xa' ->
    (match xb with
     | [] -> []
     | b :: xb' -> (Nat.compare a b) :: (cmpcol xa' xb'))

(** val getc : vst -> int -> col **)

let getc s r =
  nth r s.cols []

(** val vstep : vst -> instr -> vst **)

let vstep s = function
| Mov (d, r) ->
  { cols = (setn s.cols d (getc s r)); flags = s.flags; dn = s.dn }
| Cmp (a, b) ->
  { cols = s.cols; flags = (cmpcol (getc s a) (getc s b)); dn = s.dn }
| Cmov (c, d, r) ->
  { cols = (setn s.cols d (blend c s.flags (getc s d) (getc s r))); flags =
    s.flags; dn = s.dn }

(** val vinit : int -> int -> int list list -> vst **)

let vinit n r reps =
  { cols =
    (map (fun r0 ->
      if Nat.ltb r0 n
      then map (fun rep -> nth r0 rep 0) reps
      else repeat n (length reps)) (seq 0 r));
    flags = (repeat Eq (length reps)); dn = (repeat false n) }

(** val tgt : int list list -> int -> col **)

let tgt reps j =
  map (fun rep -> nth j (NatSort.sort rep) 0) reps

(** val swapc : cond -> cond **)

let swapc = function
| CL -> CG
| CG -> CL
| CLE -> CGE
| CGE -> CLE

(** val negflags : vst -> vst **)

let negflags s =
  { cols = s.cols; flags = (map compOpp s.flags); dn = s.dn }

(** val lexc : int list -> int list -> comparison **)

let rec lexc a b =
  match a with
  | [] -> (match b with
           | [] -> Eq
           | _ :: _ -> Lt)
  | x :: a' ->
    (match b with
     | [] -> Gt
     | y :: b' ->
       if (=) x y then lexc a' b' else if Nat.ltb x y then Lt else Gt)

(** val gtb : col -> col -> bool **)

let gtb a b =
  match lexc a b with
  | Gt -> true
  | _ -> false

(** val ltb' : col -> col -> bool **)

let ltb' a b =
  match lexc a b with
  | Lt -> true
  | _ -> false

(** val carry : (col -> col -> bool) -> col -> col list -> col list **)

let rec carry ord x = function
| [] -> x :: []
| y :: t' -> if ord x y then y :: (carry ord x t') else x :: (carry ord y t')

(** val pass : (col -> col -> bool) -> col list -> col list **)

let pass ord = function
| [] -> []
| x :: t0 -> carry ord x t0

(** val sortcols : col list -> col list **)

let sortcols l =
  rev_append (pass ltb' (rev_append (pass gtb l) [])) []

(** val firstne : comparison list -> comparison **)

let rec firstne = function
| [] -> Eq
| f :: t0 -> (match f with
              | Eq -> firstne t0
              | _ -> f)

(** val normflags : vst -> vst **)

let normflags s =
  match firstne s.flags with
  | Gt -> negflags s
  | _ -> s

(** val canon : vst -> vst **)

let canon s =
  normflags { cols = (sortcols s.cols); flags = s.flags; dn = s.dn }

(** val col_eqb : int list -> int list -> bool **)

let rec col_eqb a b =
  match a with
  | [] -> (match b with
           | [] -> true
           | _ :: _ -> false)
  | x :: a' ->
    (match b with
     | [] -> false
     | y :: b' -> (&&) ((=) x y) (col_eqb a' b'))

(** val deadb : int -> int list list -> col list -> vst -> bool **)

let deadb n reps =
  let w = length reps in
  (fun tg s ->
  existsb (fun w0 ->
    existsb (fun j ->
      (&&) (negb (nth j s.dn false))
        (forallb (fun c -> negb ((=) (nth w0 c 0) (nth w0 (nth j tg []) 0)))
          s.cols))
      (seq 0 n))
    (seq 0 w))

(** val hw : int -> vst -> int **)

let hw n s =
  length (filter (fun j -> negb (nth j s.dn false)) (seq 0 n))

(** val findpos : int -> int -> int list -> int **)

let rec findpos n v = function
| [] -> Stdlib.Int.succ (add n v)
| h :: t0 -> if (=) h v then 0 else Stdlib.Int.succ (findpos n v t0)

(** val idx : int -> int list list -> int -> int -> int **)

let idx n reps w v =
  if (=) v n then n else findpos n v (nth w reps [])

(** val fcode : comparison -> int **)

let fcode = function
| Eq -> Stdlib.Int.succ 0
| Lt -> 0
| Gt -> Stdlib.Int.succ (Stdlib.Int.succ 0)

(** val key : int -> int list list -> vst -> int -> int list **)

let key n reps s w =
  (fcode (nth w s.flags Eq)) :: (app
                                  (map (fun c -> idx n reps w (nth w c 0))
                                    s.cols)
                                  (map (fun j ->
                                    if nth j s.dn false
                                    then findpos n j (nth w reps [])
                                    else 0) (seq 0 n)))

(** val hcb : int -> int list list -> int list -> vst -> int -> bool **)

let hcb n reps strict s b =
  let lim = Nat.pow (Stdlib.Int.succ (Stdlib.Int.succ 0)) (sub b (hw n s)) in
  (&&) (Nat.ltb lim (length strict))
    (let ks = map (key n reps s) strict in
     existsb (fun k -> Nat.ltb lim (length (filter (col_eqb k) ks))) ks)

(** val prune :
    int -> int list list -> col list -> int list -> vst -> int -> bool **)

let prune n reps tg strict s b =
  (||) ((||) (Nat.ltb b (hw n s)) (deadb n reps tg s)) (hcb n reps strict s b)

module PositiveMap =
 struct
  type key = positive

  type 'a tree =
  | Leaf
  | Node of 'a tree * 'a option * 'a tree

  type 'a t = 'a tree

  (** val empty : 'a1 t **)

  let empty =
    Leaf

  (** val find : key -> 'a1 t -> 'a1 option **)

  let rec find i = function
  | Leaf -> None
  | Node (l, o, r) ->
    (match i with
     | XI ii -> find ii r
     | XO ii -> find ii l
     | XH -> o)

  (** val add : key -> 'a1 -> 'a1 t -> 'a1 t **)

  let rec add i v = function
  | Leaf ->
    (match i with
     | XI ii -> Node (Leaf, None, (add ii v Leaf))
     | XO ii -> Node ((add ii v Leaf), None, Leaf)
     | XH -> Node (Leaf, (Some v), Leaf))
  | Node (l, o, r) ->
    (match i with
     | XI ii -> Node (l, o, (add ii v r))
     | XO ii -> Node ((add ii v l), o, r)
     | XH -> Node (l, (Some v), r))
 end

(** val conds : (cond -> bool) -> cond list **)

let conds iset =
  filter iset (CL :: (CG :: (CLE :: (CGE :: []))))

(** val vwfb : int -> int list list -> vst -> bool **)

let vwfb r reps =
  let w = length reps in
  (fun s ->
  (&&)
    ((&&) ((=) (length s.cols) r)
      (forallb (fun c -> (=) (length c) w) s.cols))
    ((=) (length s.flags) w))

(** val hasb : col list -> vst -> int -> bool **)

let hasb tg s j =
  existsb (fun c -> col_eqb c (nth j tg [])) s.cols

(** val markb : int -> col list -> vst -> vst **)

let markb n tg s =
  { cols = s.cols; flags = s.flags; dn =
    (map (fun j -> if nth j s.dn false then true else hasb tg s j) (seq 0 n)) }

(** val markedb : int -> col list -> vst -> bool **)

let markedb n tg s =
  forallb (fun j -> implb (hasb tg s j) (nth j s.dn false)) (seq 0 n)

(** val alldoneb : int -> vst -> bool **)

let alldoneb n s =
  forallb (fun j -> nth j s.dn false) (seq 0 n)

(** val ofn : int -> Uint63.t **)

let rec ofn x =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> (Uint63.of_int (0)))
    (fun x' ->
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> (Uint63.of_int (1)))
      (fun n0 ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> (Uint63.of_int (2)))
        (fun n1 ->
        (fun fO fS n -> if n=0 then fO () else fS (n-1))
          (fun _ -> (Uint63.of_int (3)))
          (fun n2 ->
          (fun fO fS n -> if n=0 then fO () else fS (n-1))
            (fun _ -> (Uint63.of_int (4)))
            (fun _ -> add0 (ofn x') (Uint63.of_int (1)))
            n2)
          n1)
        n0)
      x')
    x

(** val hstep : Uint63.t -> int -> Uint63.t **)

let hstep h x =
  add0 (mul0 h (Uint63.of_int (31))) (ofn x)

(** val hflag : Uint63.t -> comparison -> Uint63.t **)

let hflag h f =
  hstep h (fcode f)

(** val hdn : Uint63.t -> bool -> Uint63.t **)

let hdn h b =
  hstep h (if b then Stdlib.Int.succ 0 else 0)

(** val hraw : vst -> Uint63.t **)

let hraw s =
  fold_left hdn s.dn
    (fold_left hflag s.flags
      (fold_left (fun h c -> fold_left hstep c (mul0 h (Uint63.of_int (7))))
        s.cols (Uint63.of_int (1))))

(** val pk : int -> Uint63.t -> positive **)

let rec pk k h =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> XH)
    (fun k' ->
    if eqb0 (land0 h (Uint63.of_int (1))) (Uint63.of_int (0))
    then XO (pk k' (lsr0 h (Uint63.of_int (1))))
    else XI (pk k' (lsr0 h (Uint63.of_int (1)))))
    k

(** val hkey : vst -> positive **)

let hkey s =
  pk (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ 0))))))))))))))))))))))
    (lsr0 (mul0 (hraw s) (Uint63.of_int (-3351591030290773355)))
      (Uint63.of_int (40)))

(** val list_eqb : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool **)

let rec list_eqb e a b =
  match a with
  | [] -> (match b with
           | [] -> true
           | _ :: _ -> false)
  | x :: a' ->
    (match b with
     | [] -> false
     | y :: b' -> (&&) (e x y) (list_eqb e a' b'))

(** val cmp_eqb : comparison -> comparison -> bool **)

let cmp_eqb f g =
  (=) (fcode f) (fcode g)

(** val vst_eqb : vst -> vst -> bool **)

let vst_eqb s t0 =
  (&&)
    ((&&) (list_eqb col_eqb s.cols t0.cols)
      (list_eqb cmp_eqb s.flags t0.flags))
    (list_eqb eqb s.dn t0.dn)

type bucket = (vst * int) list

type tbl = bucket PositiveMap.t

(** val blook : vst -> bucket -> int option **)

let rec blook t0 = function
| [] -> None
| p :: bk' -> let (s, b) = p in if vst_eqb s t0 then Some b else blook t0 bk'

(** val tlookh : (vst -> positive) -> tbl -> vst -> int option **)

let tlookh hk m t0 =
  match PositiveMap.find (hk t0) m with
  | Some bk -> blook t0 bk
  | None -> None

(** val taddh : (vst -> positive) -> tbl -> vst -> int -> tbl **)

let taddh hk m s b =
  PositiveMap.add (hk s) ((s,
    b) :: (match PositiveMap.find (hk s) m with
           | Some bk -> bk
           | None -> []))
    m

(** val buildh : (vst -> positive) -> (vst * int) list -> tbl **)

let buildh hk v =
  fold_left (fun m e -> taddh hk m (fst e) (snd e)) v PositiveMap.empty

(** val tlook : tbl -> vst -> int option **)

let tlook =
  tlookh hkey

(** val tadd : tbl -> vst -> int -> tbl **)

let tadd =
  taddh hkey

(** val build : (vst * int) list -> tbl **)

let build =
  buildh hkey

(** val isrep : vst -> int -> bool **)

let isrep s r =
  forallb (fun r' -> negb (col_eqb (getc s r') (getc s r))) (seq 0 r)

(** val rinstrs : int -> (cond -> bool) -> vst -> instr list **)

let rinstrs r iset s =
  flat_map (fun d ->
    if isrep s d
    then flat_map (fun r0 ->
           if isrep s r0
           then (Cmp (d,
                  r0)) :: (if (=) d r0
                           then []
                           else (Mov (d,
                                  r0)) :: (map (fun c -> Cmov (c, d, r0))
                                            (conds iset)))
           else []) (seq 0 r)
    else []) (seq 0 r)

(** val succ : int -> col list -> vst -> instr -> vst **)

let succ n tg s i =
  markb n tg (canon (vstep s i))

(** val covered :
    int -> int list list -> col list -> int list -> tbl -> vst -> int -> bool **)

let covered n reps tg strict m t0 b =
  (||) (match tlook m t0 with
        | Some b' -> (<=) b b'
        | None -> false)
    (prune n reps tg strict t0 b)

(** val check_entry :
    int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
    tbl -> (vst * int) -> bool **)

let check_entry n r reps tg strict iset m = function
| (s, b) ->
  (&&) ((&&) ((&&) (vwfb r reps s) (markedb n tg s)) (negb (alldoneb n s)))
    ((fun fO fS n -> if n=0 then fO () else fS (n-1))
       (fun _ -> true)
       (fun b' ->
       forallb (fun i -> covered n reps tg strict m (succ n tg s i) b')
         (rinstrs r iset s))
       b)

(** val root : int -> int -> int list list -> col list -> vst **)

let root n r reps tg =
  markb n tg (canon (vinit n r reps))

(** val check_from :
    int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
    tbl -> int -> int -> int -> (vst * int) list -> bool **)

let rec check_from n r reps tg strict iset m n0 i j = function
| [] -> true
| e :: v' ->
  (&&)
    (if (=) (Nat.modulo j n0) i
     then check_entry n r reps tg strict iset m e
     else true)
    (check_from n r reps tg strict iset m n0 i (Stdlib.Int.succ j) v')

(** val expand :
    int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
    int -> (vst list * tbl) -> vst -> vst list * tbl **)

let expand n r reps tg strict iset b' st s =
  fold_left (fun st0 i ->
    let (nx, m) = st0 in
    let t0 = succ n tg s i in
    (match tlook m t0 with
     | Some _ -> st0
     | None ->
       if prune n reps tg strict t0 b'
       then st0
       else ((t0 :: nx), (tadd m t0 b'))))
    (rinstrs r iset s) st

(** val layers :
    int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
    int -> vst list -> tbl -> (vst * int) list -> (vst * int) list **)

let rec layers n r reps tg strict iset b front m acc =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> acc)
    (fun b' ->
    let (nx, m') = fold_left (expand n r reps tg strict iset b') front ([], m)
    in
    layers n r reps tg strict iset b' nx m'
      (fold_left (fun a t0 -> (t0, b') :: a) nx acc))
    b

(** val search :
    int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
    int -> (vst * int) list **)

let search n r reps tg strict iset k =
  let r0 = root n r reps tg in
  layers n r reps tg strict iset k (r0 :: []) (tadd PositiveMap.empty r0 k)
    ((r0, k) :: [])

(** val nodupb : int list -> bool **)

let rec nodupb = function
| [] -> true
| x :: t0 -> (&&) (negb (existsb ((=) x) t0)) (nodupb t0)

(** val reps_okb : int -> int list list -> bool **)

let reps_okb n reps =
  forallb (fun rep ->
    (&&) ((=) (length rep) n) (forallb (fun v -> Nat.ltb v n) rep)) reps

(** val strict_okb : int -> int list list -> int list -> bool **)

let strict_okb n reps strict =
  (&&)
    ((&&)
      (forallb (fun w ->
        (&&) ((&&) (Nat.ltb w (length reps)) (nodupb (nth w reps [])))
          (col_eqb (NatSort.sort (nth w reps [])) (seq 0 n)))
        strict)
      (nodupb strict))
    (forallb (fun w1 ->
      forallb (fun w2 ->
        implb (col_eqb (nth w1 reps []) (nth w2 reps [])) ((=) w1 w2)) strict)
      strict)

(** val tg_okb : int -> int list list -> col list -> bool **)

let tg_okb n reps tg =
  forallb (fun j -> col_eqb (nth j tg []) (tgt reps j)) (seq 0 n)

(** val tdist_okb : int -> col list -> bool **)

let tdist_okb n tg =
  forallb (fun j1 ->
    forallb (fun j2 ->
      implb (col_eqb (nth j1 tg []) (nth j2 tg [])) ((=) j1 j2)) (seq 0 n))
    (seq 0 n)

(** val sym_okb : (cond -> bool) -> bool **)

let sym_okb iset =
  forallb (fun c -> eqb (iset (swapc c)) (iset c))
    (CL :: (CG :: (CLE :: (CGE :: []))))

(** val pre_okb :
    int -> int -> int list list -> col list -> int list -> (cond -> bool) ->
    (vst * int) list -> int -> bool **)

let pre_okb n r reps tg strict iset v k =
  (&&)
    ((&&)
      ((&&)
        ((&&)
          ((&&)
            ((&&) ((&&) ((<=) (Stdlib.Int.succ 0) n) ((<=) n r))
              (reps_okb n reps))
            (tg_okb n reps tg))
          (tdist_okb n tg))
        (strict_okb n reps strict))
      (sym_okb iset))
    (match tlook (build v) (root n r reps tg) with
     | Some b -> (<=) k b
     | None -> false)

(** val reps3 : int list list **)

let reps3 =
  (0 :: ((Stdlib.Int.succ 0) :: ((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: []))) :: ((0 :: ((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: ((Stdlib.Int.succ 0) :: []))) :: (((Stdlib.Int.succ
    0) :: (0 :: ((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: []))) :: (((Stdlib.Int.succ 0) :: ((Stdlib.Int.succ
    (Stdlib.Int.succ 0)) :: (0 :: []))) :: (((Stdlib.Int.succ
    (Stdlib.Int.succ 0)) :: (0 :: ((Stdlib.Int.succ
    0) :: []))) :: (((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: ((Stdlib.Int.succ 0) :: (0 :: []))) :: [])))))

(** val strict3 : int list **)

let strict3 =
  0 :: ((Stdlib.Int.succ 0) :: ((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: ((Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    0))) :: ((Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ 0)))) :: ((Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0))))) :: [])))))

(** val tg3 : col list **)

let tg3 =
  (0 :: (0 :: (0 :: (0 :: (0 :: (0 :: [])))))) :: (((Stdlib.Int.succ
    0) :: ((Stdlib.Int.succ 0) :: ((Stdlib.Int.succ 0) :: ((Stdlib.Int.succ
    0) :: ((Stdlib.Int.succ 0) :: ((Stdlib.Int.succ
    0) :: [])))))) :: (((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: ((Stdlib.Int.succ (Stdlib.Int.succ 0)) :: ((Stdlib.Int.succ
    (Stdlib.Int.succ 0)) :: ((Stdlib.Int.succ (Stdlib.Int.succ
    0)) :: ((Stdlib.Int.succ (Stdlib.Int.succ 0)) :: ((Stdlib.Int.succ
    (Stdlib.Int.succ 0)) :: [])))))) :: []))

(** val iset_of : bool -> cond -> bool **)

let iset_of = function
| true -> cond_inI1
| false -> cond_inI0

(** val cert3 : bool -> int -> (vst * int) list **)

let cert3 i1 k =
  search (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0)))
    (add (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0))) k) reps3 tg3
    strict3 (iset_of i1) k

(** val pre3 : bool -> int -> (vst * int) list -> bool **)

let pre3 i1 k v =
  pre_okb (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0)))
    (add (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0))) k) reps3 tg3
    strict3 (iset_of i1) v k

(** val table3 : (vst * int) list -> tbl **)

let table3 =
  build

(** val chunk3 :
    bool -> int -> tbl -> (vst * int) list -> int -> int -> bool **)

let chunk3 i1 k m v n i =
  check_from (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0)))
    (add (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0))) k) reps3 tg3
    strict3 (iset_of i1) m n i 0 v
