
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

type 'a sig0 = 'a
  (* singleton inductive, whose constructor was exist *)



(** val add : int -> int -> int **)

let rec add = (+)

(** val sub : int -> int -> int **)

let rec sub = fun n m -> Stdlib.max 0 (n-m)

(** val sumbool_of_bool : bool -> bool **)

let sumbool_of_bool = function
| true -> true
| false -> false

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

  (** val ltb : int -> int -> bool **)

  let ltb n m =
    (<=) (Stdlib.Int.succ n) m

  (** val compare : int -> int -> comparison **)

  let rec compare = fun n m -> if n=m then Eq else if n<m then Lt else Gt

  (** val max : int -> int -> int **)

  let rec max n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> m)
      (fun n' ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> n)
        (fun m' -> Stdlib.Int.succ (max n' m'))
        m)
      n

  (** val pow : int -> int -> int **)

  let rec pow n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ -> Stdlib.Int.succ 0)
      (fun m0 -> mul n (pow n m0))
      m
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

(** val remove : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> 'a1 list **)

let rec remove eq_dec x = function
| [] -> []
| y :: tl ->
  if eq_dec x y then remove eq_dec x tl else y :: (remove eq_dec x tl)

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

(** val tgt : int list list -> int -> col **)

let tgt reps j =
  map (fun rep -> nth j (NatSort.sort rep) 0) reps

(** val swapc : cond -> cond **)

let swapc = function
| CL -> CG
| CG -> CL
| CLE -> CGE
| CGE -> CLE

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

(** val firstne : comparison list -> comparison **)

let rec firstne = function
| [] -> Eq
| f :: t0 -> (match f with
              | Eq -> firstne t0
              | _ -> f)

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

(** val pk : int -> Uint63.t -> positive **)

let rec pk k h =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> XH)
    (fun k' ->
    if eqb0 (land0 h (Uint63.of_int (1))) (Uint63.of_int (0))
    then XO (pk k' (lsr0 h (Uint63.of_int (1))))
    else XI (pk k' (lsr0 h (Uint63.of_int (1)))))
    k

type ('c, 'f) sst = { sA : 'c list; sf : 'f; sdn : bool list }

type 'c sop =
| SCmp of 'c * 'c
| SIn of cond * 'c * 'c
| SCopy of cond * 'c * 'c

(** val memb : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> bool **)

let memb ceqb x l =
  existsb (ceqb x) l

(** val addc : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 -> 'a1 list -> 'a1 list **)

let addc ceqb tp x l =
  if ceqb x tp then l else if memb ceqb x l then l else x :: l

(** val remc : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> 'a1 list **)

let remc ceqb x l =
  filter (fun y -> negb (ceqb x y)) l

(** val smark :
    int -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst -> ('a1,
    'a2) sst **)

let smark n ceqb tp tgp s =
  { sA = s.sA; sf = s.sf; sdn =
    (map (fun j ->
      if nth j s.sdn false then true else memb ceqb (nth j tgp tp) s.sA)
      (seq 0 n)) }

(** val sstep :
    int -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 -> 'a1) -> ('a1
    -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst -> 'a1 sop -> ('a1,
    'a2) sst **)

let sstep n ceqb blendp cmpp tp tgp s o =
  smark n ceqb tp tgp
    (match o with
     | SCmp (a, b) -> { sA = s.sA; sf = (cmpp a b); sdn = s.sdn }
     | SIn (c, d, x) ->
       { sA = (addc ceqb tp (blendp c s.sf d x) (remc ceqb d s.sA)); sf =
         s.sf; sdn = s.sdn }
     | SCopy (c, d, x) ->
       { sA = (addc ceqb tp (blendp c s.sf d x) s.sA); sf = s.sf; sdn =
         s.sdn })

(** val cost : 'a1 sop -> int **)

let cost = function
| SCopy (_, _, _) -> Stdlib.Int.succ (Stdlib.Int.succ 0)
| _ -> Stdlib.Int.succ 0

(** val negS : ('a2 -> 'a2) -> ('a1, 'a2) sst -> ('a1, 'a2) sst **)

let negS negp t0 =
  { sA = t0.sA; sf = (negp t0.sf); sdn = t0.sdn }

(** val undone : int -> ('a1, 'a2) sst -> int **)

let undone n t0 =
  length (filter (fun j -> negb (nth j t0.sdn false)) (seq 0 n))

(** val idxS : int -> int list list -> int -> int -> int **)

let idxS =
  idx

(** val keyS :
    int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> ('a1,
    'a2) sst -> int -> int list **)

let keyS n reps dec decf t0 w =
  (fcode (nth w (decf t0.sf) Eq)) :: (app
                                       (map (fun a ->
                                         idxS n reps w (nth w (dec a) 0))
                                         t0.sA)
                                       (map (fun j ->
                                         if nth j t0.sdn false
                                         then findpos n j (nth w reps [])
                                         else 0) (seq 0 n)))

(** val hcbS :
    int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> int
    list -> ('a1, 'a2) sst -> int -> bool **)

let hcbS n reps dec decf strict t0 b =
  let u = undone n t0 in
  let ok = fun c ->
    forallb (fun x ->
      (||) (Nat.ltb (Nat.pow (Stdlib.Int.succ (Stdlib.Int.succ 0)) x) c)
        (Nat.ltb b (add x (Nat.max u x))))
      (seq 0 (Stdlib.Int.succ b))
  in
  (&&) (ok (length strict))
    (let ks = map (keyS n reps dec decf t0) strict in
     existsb (fun k -> ok (length (filter (col_eqb k) ks))) ks)

(** val deadSb :
    int -> int list list -> ('a1 -> col) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst
    -> bool **)

let deadSb n reps dec tp tgp t0 =
  let w = length reps in
  existsb (fun w0 ->
    existsb (fun j ->
      (&&) (negb (nth j t0.sdn false))
        (forallb (fun a ->
          negb ((=) (nth w0 (dec a) 0) (nth w0 (dec (nth j tgp tp)) 0)))
          t0.sA))
      (seq 0 n))
    (seq 0 w)

(** val pruneS :
    int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> 'a1
    -> 'a1 list -> int list -> ('a1, 'a2) sst -> int -> bool **)

let pruneS n reps dec decf tp tgp strict t0 b =
  (||) ((||) (Nat.ltb b (undone n t0)) (deadSb n reps dec tp tgp t0))
    (hcbS n reps dec decf strict t0 b)

(** val insC : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> 'a1 list **)

let rec insC cmpC x l = match l with
| [] -> x :: []
| y :: l' -> if cmpC x y then x :: l else y :: (insC cmpC x l')

(** val sortC : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list **)

let rec sortC cmpC = function
| [] -> []
| x :: l' -> insC cmpC x (sortC cmpC l')

(** val canon1 :
    ('a2 -> 'a2) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) -> ('a1, 'a2)
    sst -> ('a1, 'a2) sst **)

let canon1 negp cmpC firstnep t0 =
  let t1 = { sA = (sortC cmpC t0.sA); sf = t0.sf; sdn = t0.sdn } in
  (match firstnep t0.sf with
   | Gt -> negS negp t1
   | _ -> t1)

(** val rp : int list list -> int list -> col -> col **)

let rp reps =
  let w = length reps in
  (fun pi l -> map (fun w0 -> nth (nth w0 pi 0) l 0) (seq 0 w))

(** val rpf :
    int list list -> int list -> comparison list -> comparison list **)

let rpf reps =
  let w = length reps in
  (fun pi l -> map (fun w0 -> nth (nth w0 pi 0) l Eq) (seq 0 w))

(** val permS :
    (int list -> 'a1 -> 'a1) -> (int list -> 'a2 -> 'a2) -> int list -> ('a1,
    'a2) sst -> ('a1, 'a2) sst **)

let permS permc permf pi t0 =
  { sA = (map (permc pi) t0.sA); sf = (permf pi t0.sf); sdn = t0.sdn }

(** val canonS :
    ('a2 -> 'a2) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) -> (int list
    -> 'a1 -> 'a1) -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1,
    'a2) sst -> ('a1, 'a2) sst -> bool) -> ('a1, 'a2) sst -> ('a1, 'a2) sst **)

let canonS negp cmpC firstnep permc permf perms ltS0 t0 =
  fold_left (fun best pi ->
    let c = canon1 negp cmpC firstnep (permS permc permf pi t0) in
    if ltS0 c best then c else best) perms (canon1 negp cmpC firstnep t0)

(** val condsS : (cond -> bool) -> cond list **)

let condsS iset =
  filter iset (CL :: (CG :: (CLE :: (CGE :: []))))

(** val opsS : (cond -> bool) -> 'a1 -> ('a1, 'a2) sst -> 'a1 sop list **)

let opsS iset tp t0 =
  let xs = tp :: t0.sA in
  flat_map (fun a ->
    flat_map (fun b -> (SCmp (a,
      b)) :: (flat_map (fun c -> (SIn (c, a, b)) :: ((SCopy (c, a,
               b)) :: [])) (condsS iset)))
      xs)
    xs

(** val lsteqb : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool **)

let rec lsteqb e a b =
  match a with
  | [] -> (match b with
           | [] -> true
           | _ :: _ -> false)
  | x :: a' ->
    (match b with
     | [] -> false
     | y :: b' -> (&&) (e x y) (lsteqb e a' b'))

(** val sst_eqb :
    ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1, 'a2) sst -> ('a1,
    'a2) sst -> bool **)

let sst_eqb ceqb feqb t0 u =
  (&&) ((&&) (lsteqb ceqb t0.sA u.sA) (feqb t0.sf u.sf))
    (lsteqb eqb t0.sdn u.sdn)

type ('c, 'f) sbucket = (('c, 'f) sst * int) list

type ('c, 'f) stbl = ('c, 'f) sbucket PositiveMap.t

(** val sblook :
    ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1, 'a2) sst -> ('a1,
    'a2) sbucket -> int option **)

let rec sblook ceqb feqb t0 = function
| [] -> None
| p :: bk' ->
  let (u, b) = p in
  if sst_eqb ceqb feqb u t0 then Some b else sblook ceqb feqb t0 bk'

(** val stlook :
    ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> (('a1, 'a2) sst ->
    positive) -> ('a1, 'a2) stbl -> ('a1, 'a2) sst -> int option **)

let stlook ceqb feqb hashS m t0 =
  match PositiveMap.find (hashS t0) m with
  | Some bk -> sblook ceqb feqb t0 bk
  | None -> None

(** val stadd :
    (('a1, 'a2) sst -> positive) -> ('a1, 'a2) stbl -> ('a1, 'a2) sst -> int
    -> ('a1, 'a2) stbl **)

let stadd hashS m t0 b =
  PositiveMap.add (hashS t0) ((t0,
    b) :: (match PositiveMap.find (hashS t0) m with
           | Some bk -> bk
           | None -> []))
    m

(** val sbuild :
    (('a1, 'a2) sst -> positive) -> (('a1, 'a2) sst * int) list -> ('a1, 'a2)
    stbl **)

let sbuild hashS v =
  fold_left (fun m e -> stadd hashS m (fst e) (snd e)) v PositiveMap.empty

(** val domb :
    int -> ('a1 -> 'a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1, 'a2) sst ->
    ('a1, 'a2) sst -> bool **)

let domb n ceqb feqb u t0 =
  (&&) ((&&) (forallb (fun x -> memb ceqb x t0.sA) u.sA) (feqb u.sf t0.sf))
    (forallb (fun j -> implb (nth j u.sdn false) (nth j t0.sdn false))
      (seq 0 n))

(** val smarkedb :
    int -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> ('a1, 'a2) sst -> bool **)

let smarkedb n ceqb tp tgp t0 =
  forallb (fun j ->
    implb (memb ceqb (nth j tgp tp) t0.sA) (nth j t0.sdn false)) (seq 0 n)

(** val sdoneb : int -> ('a1, 'a2) sst -> bool **)

let sdoneb n t0 =
  forallb (fun j -> nth j t0.sdn false) (seq 0 n)

(** val scovered :
    int -> int list list -> ('a1 -> col) -> ('a2 -> comparison list) -> ('a1
    -> 'a1 -> bool) -> 'a1 -> 'a1 list -> int list -> ('a2 -> 'a2 -> bool) ->
    (('a1, 'a2) sst -> positive) -> ('a1, 'a2) stbl -> ('a1, 'a2) sst -> int
    -> bool **)

let scovered n reps dec decf ceqb tp tgp strict feqb hashS m t0 b =
  (||)
    (match stlook ceqb feqb hashS m t0 with
     | Some b' -> (<=) b b'
     | None -> false)
    (pruneS n reps dec decf tp tgp strict t0 b)

(** val scheck_entry :
    int -> int list list -> (cond -> bool) -> ('a1 -> col) -> ('a2 ->
    comparison list) -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 ->
    'a1) -> ('a1 -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a2 -> 'a2) -> int
    list -> ('a2 -> 'a2 -> bool) -> ('a1 -> 'a1 -> bool) -> ('a2 ->
    comparison) -> (('a1, 'a2) sst -> positive) -> (int list -> 'a1 -> 'a1)
    -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst -> ('a1,
    'a2) sst -> bool) -> ('a1, 'a2) stbl -> (('a1, 'a2) sst * int) -> bool **)

let scheck_entry n reps iset dec decf ceqb blendp cmpp tp tgp negp strict feqb cmpC firstnep hashS permc permf perms ltS0 m = function
| (t0, b) ->
  (&&) ((&&) (smarkedb n ceqb tp tgp t0) (negb (sdoneb n t0)))
    (forallb (fun o ->
      if (<=) (cost o) b
      then (||) (domb n ceqb feqb (sstep n ceqb blendp cmpp tp tgp t0 o) t0)
             (scovered n reps dec decf ceqb tp tgp strict feqb hashS m
               (canonS negp cmpC firstnep permc permf perms ltS0
                 (sstep n ceqb blendp cmpp tp tgp t0 o))
               (sub b (cost o)))
      else true) (opsS iset tp t0))

(** val scheck :
    int -> int list list -> (cond -> bool) -> ('a1 -> col) -> ('a2 ->
    comparison list) -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 ->
    'a1) -> ('a1 -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a2 -> 'a2) -> int
    list -> ('a2 -> 'a2 -> bool) -> ('a1 -> 'a1 -> bool) -> ('a2 ->
    comparison) -> (('a1, 'a2) sst -> positive) -> (int list -> 'a1 -> 'a1)
    -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst -> ('a1,
    'a2) sst -> bool) -> (('a1, 'a2) sst * int) list -> bool **)

let scheck n reps iset dec decf ceqb blendp cmpp tp tgp negp strict feqb cmpC firstnep hashS permc permf perms ltS0 v =
  let m = sbuild hashS v in
  forallb
    (scheck_entry n reps iset dec decf ceqb blendp cmpp tp tgp negp strict
      feqb cmpC firstnep hashS permc permf perms ltS0 m)
    v

(** val incol : int list list -> int -> col **)

let incol reps r =
  map (fun rep -> nth r rep 0) reps

(** val inputsC : int -> int list list -> (col -> 'a1) -> 'a1 list **)

let inputsC n reps encp =
  map (fun r -> encp (incol reps r)) (seq 0 n)

(** val root0 :
    int -> int list list -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> (col
    -> 'a1) -> (comparison list -> 'a2) -> ('a1, 'a2) sst **)

let root0 n reps ceqb tp tgp encp encf =
  let w = length reps in
  smark n ceqb tp tgp { sA = (inputsC n reps encp); sf =
    (encf (repeat Eq w)); sdn = (repeat false n) }

(** val rootS :
    int -> int list list -> ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> ('a2
    -> 'a2) -> ('a1 -> 'a1 -> bool) -> ('a2 -> comparison) -> (int list ->
    'a1 -> 'a1) -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1, 'a2)
    sst -> ('a1, 'a2) sst -> bool) -> (col -> 'a1) -> (comparison list ->
    'a2) -> ('a1, 'a2) sst **)

let rootS n reps ceqb tp tgp negp cmpC firstnep permc permf perms ltS0 encp encf =
  canonS negp cmpC firstnep permc permf perms ltS0
    (root0 n reps ceqb tp tgp encp encf)

(** val inputs_distinct : int -> int list list -> bool **)

let inputs_distinct n reps =
  forallb (fun r1 ->
    forallb (fun r2 ->
      implb (col_eqb (incol reps r1) (incol reps r2)) ((=) r1 r2)) (seq 0 n))
    (seq 0 n)

(** val scertifies :
    int -> int list list -> (cond -> bool) -> ('a1 -> col) -> ('a2 ->
    comparison list) -> ('a1 -> 'a1 -> bool) -> (cond -> 'a2 -> 'a1 -> 'a1 ->
    'a1) -> ('a1 -> 'a1 -> 'a2) -> 'a1 -> 'a1 list -> ('a2 -> 'a2) -> int
    list -> ('a2 -> 'a2 -> bool) -> ('a1 -> 'a1 -> bool) -> ('a2 ->
    comparison) -> (('a1, 'a2) sst -> positive) -> (int list -> 'a1 -> 'a1)
    -> (int list -> 'a2 -> 'a2) -> int list list -> (('a1, 'a2) sst -> ('a1,
    'a2) sst -> bool) -> (col -> 'a1) -> (comparison list -> 'a2) -> (('a1,
    'a2) sst * int) list -> int -> bool **)

let scertifies n reps iset dec decf ceqb blendp cmpp tp tgp negp strict feqb cmpC firstnep hashS permc permf perms ltS0 encp encf v k =
  (&&)
    ((&&) (inputs_distinct n reps)
      (scheck n reps iset dec decf ceqb blendp cmpp tp tgp negp strict feqb
        cmpC firstnep hashS permc permf perms ltS0 v))
    (match stlook ceqb feqb hashS (sbuild hashS v)
             (rootS n reps ceqb tp tgp negp cmpC firstnep permc permf perms
               ltS0 encp encf) with
     | Some b -> (<=) k b
     | None -> false)

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

type lC = int list

type lF = comparison list

(** val ldec : int list list -> lC -> col **)

let ldec _ a =
  a

(** val ldecf : int list list -> lF -> comparison list **)

let ldecf _ f =
  f

(** val lblend : int list list -> cond -> lF -> lC -> lC -> lC **)

let lblend reps c f a b =
  blend c (ldecf reps f) (ldec reps a) (ldec reps b)

(** val lcmp : int list list -> lC -> lC -> lF **)

let lcmp reps a b =
  cmpcol (ldec reps a) (ldec reps b)

(** val lneg : int list list -> lF -> lF **)

let lneg reps f =
  map compOpp (ldecf reps f)

(** val lT : int -> int list list -> lC **)

let lT n reps =
  let w = length reps in repeat n w

(** val lenc : int -> int list list -> int list -> lC **)

let lenc n reps =
  let w = length reps in
  (fun l -> if sumbool_of_bool ((=) (length l) w) then l else lT n reps)

(** val lencf : int list list -> comparison list -> lF **)

let lencf reps =
  let w = length reps in
  (fun l -> if sumbool_of_bool ((=) (length l) w) then l else repeat Eq w)

(** val lceqb : int list list -> lC -> lC -> bool **)

let lceqb reps a b =
  col_eqb (ldec reps a) (ldec reps b)

(** val lfeqb : int list list -> lF -> lF -> bool **)

let lfeqb reps f g =
  lsteqb (fun x y -> (=) (fcode x) (fcode y)) (ldecf reps f) (ldecf reps g)

(** val lcmpC : int list list -> lC -> lC -> bool **)

let lcmpC reps a b =
  match lexc (ldec reps a) (ldec reps b) with
  | Gt -> false
  | _ -> true

(** val lfirstne : int list list -> lF -> comparison **)

let lfirstne reps f =
  firstne (ldecf reps f)

(** val ltgp : int -> int list list -> col list -> lC list **)

let ltgp n reps tg =
  map (lenc n reps) tg

(** val lhash : int list list -> (lC, lF) sst -> positive **)

let lhash reps t0 =
  pk (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ
    (Stdlib.Int.succ (Stdlib.Int.succ 0))))))))))))))))))))))
    (lsr0
      (mul0
        (fold_left hdn t0.sdn
          (fold_left hflag (ldecf reps t0.sf)
            (fold_left (fun h c ->
              fold_left hstep (ldec reps c) (mul0 h (Uint63.of_int (7))))
              t0.sA (Uint63.of_int (1)))))
        (Uint63.of_int (-3351591030290773355)))
      (Uint63.of_int (40)))

(** val lpermc : int list list -> int list -> lC -> lC **)

let lpermc reps pi a =
  rp reps pi (ldec reps a)

(** val lpermf : int list list -> int list -> lF -> lF **)

let lpermf reps pi f =
  rpf reps pi (ldecf reps f)

(** val lexl : int list list -> int list list -> comparison **)

let rec lexl a b =
  match a with
  | [] -> (match b with
           | [] -> Eq
           | _ :: _ -> Lt)
  | x :: a' ->
    (match b with
     | [] -> Gt
     | y :: b' -> (match lexc x y with
                   | Eq -> lexl a' b'
                   | x0 -> x0))

(** val ltS : int list list -> (lC, lF) sst -> (lC, lF) sst -> bool **)

let ltS reps t0 u =
  match lexl (map (ldec reps) t0.sA) (map (ldec reps) u.sA) with
  | Eq ->
    (match lexc (map fcode (ldecf reps t0.sf)) (map fcode (ldecf reps u.sf)) with
     | Lt -> true
     | _ -> false)
  | Lt -> true
  | Gt -> false

(** val perms_of : int -> int list -> int list list **)

let rec perms_of fuel l =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> match l with
              | [] -> [] :: []
              | _ :: _ -> [])
    (fun f ->
    match l with
    | [] -> [] :: []
    | _ :: _ ->
      flat_map (fun x ->
        map (fun x0 -> x :: x0) (perms_of f (remove (=) x l))) l)
    fuel

(** val index_of : int list -> int list list -> int **)

let rec index_of x = function
| [] -> 0
| y :: l' -> if col_eqb x y then 0 else Stdlib.Int.succ (index_of x l')

(** val row_perm : int -> int list list -> int list -> int list **)

let row_perm n reps =
  let w = length reps in
  (fun sigma ->
  map (fun w0 ->
    index_of
      (map (fun i -> nth (nth i sigma 0) (nth w0 reps []) 0) (seq 0 n)) reps)
    (seq 0 w))

(** val lperms : int -> int list list -> int list list **)

let lperms n reps =
  map (row_perm n reps) (perms_of n (seq 0 n))

(** val pi_okb : int -> int list list -> int list -> bool **)

let pi_okb n reps =
  let w = length reps in
  (fun pi ->
  (&&)
    ((&&) (forallb (fun w0 -> Nat.ltb (nth w0 pi 0) w) (seq 0 w))
      (forallb (fun v -> existsb (fun w0 -> (=) (nth w0 pi 0) v) (seq 0 w))
        (seq 0 w)))
    (forallb (fun j -> col_eqb (rp reps pi (tgt reps j)) (tgt reps j))
      (seq 0 n)))

(** val lsstep :
    int -> int list list -> col list -> (lC, lF) sst -> lC sop -> (lC, lF) sst **)

let lsstep n reps tg =
  sstep n (lceqb reps) (lblend reps) (lcmp reps) (lT n reps) (ltgp n reps tg)

(** val lcanon : int -> int list list -> (lC, lF) sst -> (lC, lF) sst **)

let lcanon n reps =
  canonS (lneg reps) (lcmpC reps) (lfirstne reps) (lpermc reps) (lpermf reps)
    (lperms n reps) (ltS reps)

(** val lops :
    int -> int list list -> (cond -> bool) -> (lC, lF) sst -> lC sop list **)

let lops n reps iset =
  opsS iset (lT n reps)

(** val lprune :
    int -> int list list -> col list -> int list -> (lC, lF) sst -> int ->
    bool **)

let lprune n reps tg strict =
  pruneS n reps (ldec reps) (ldecf reps) (lT n reps) (ltgp n reps tg) strict

(** val lroot : int -> int list list -> col list -> (lC, lF) sst **)

let lroot n reps tg =
  rootS n reps (lceqb reps) (lT n reps) (ltgp n reps tg) (lneg reps)
    (lcmpC reps) (lfirstne reps) (lpermc reps) (lpermf reps) (lperms n reps)
    (ltS reps) (lenc n reps) (lencf reps)

(** val llook :
    int list list -> (lC, lF) stbl -> (lC, lF) sst -> int option **)

let llook reps =
  stlook (lceqb reps) (lfeqb reps) (lhash reps)

(** val ladd :
    int list list -> (lC, lF) stbl -> (lC, lF) sst -> int -> (lC, lF) stbl **)

let ladd reps =
  stadd (lhash reps)

(** val ldom :
    int -> int list list -> (lC, lF) sst -> (lC, lF) sst -> bool **)

let ldom n reps =
  domb n (lceqb reps) (lfeqb reps)

(** val lcert :
    int -> int list list -> col list -> int list -> (cond -> bool) -> ((lC,
    lF) sst * int) list -> int -> bool **)

let lcert n reps tg strict iset =
  scertifies n reps iset (ldec reps) (ldecf reps) (lceqb reps) (lblend reps)
    (lcmp reps) (lT n reps) (ltgp n reps tg) (lneg reps) strict (lfeqb reps)
    (lcmpC reps) (lfirstne reps) (lhash reps) (lpermc reps) (lpermf reps)
    (lperms n reps) (ltS reps) (lenc n reps) (lencf reps)

(** val setb : 'a1 list -> int -> ('a1 -> 'a1) -> 'a1 list **)

let rec setb l i f =
  match l with
  | [] -> []
  | x :: t0 ->
    ((fun fO fS n -> if n=0 then fO () else fS (n-1))
       (fun _ -> (f x) :: t0)
       (fun i' -> x :: (setb t0 i' f))
       i)

type sstate = ((lC, lF) stbl * (lC, lF) sst list list) * (lC, lF) sst list

(** val visit :
    int -> int list list -> col list -> int list -> (cond -> bool) -> int ->
    sstate -> (lC, lF) sst -> sstate **)

let visit n reps tg strict iset b st t0 =
  match llook reps (fst (fst st)) t0 with
  | Some bt ->
    if (=) bt b
    then fold_left (fun st0 o ->
           if (&&) ((<=) (cost o) b)
                (negb (ldom n reps (lsstep n reps tg t0 o) t0))
           then let u = lcanon n reps (lsstep n reps tg t0 o) in
                let b' = sub b (cost o) in
                let (p, all) = st0 in
                let (m, bk) = p in
                if lprune n reps tg strict u b'
                then st0
                else (match llook reps m u with
                      | Some bu ->
                        if Nat.ltb bu b'
                        then (((ladd reps m u b'),
                               (setb bk b' (fun x -> u :: x))), all)
                        else st0
                      | None ->
                        (((ladd reps m u b'),
                          (setb bk b' (fun x -> u :: x))), (u :: all)))
           else st0) (lops n reps iset t0) st
    else st
  | None -> st

(** val levels :
    int -> int list list -> col list -> int list -> (cond -> bool) -> int ->
    int -> sstate -> sstate **)

let rec levels n reps tg strict iset fuel b st =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> st)
    (fun f ->
    let st' =
      fold_left (visit n reps tg strict iset b) (nth b (snd (fst st)) []) st
    in
    ((fun fO fS n -> if n=0 then fO () else fS (n-1))
       (fun _ -> st')
       (fun b' -> levels n reps tg strict iset f b' st')
       b))
    fuel

(** val ssearch :
    int -> int list list -> col list -> int list -> (cond -> bool) -> int ->
    ((lC, lF) sst * int) list **)

let ssearch n reps tg strict iset k =
  let r = lroot n reps tg in
  let m0 = ladd reps PositiveMap.empty r k in
  let bk0 = setb (repeat [] (Stdlib.Int.succ k)) k (fun x -> r :: x) in
  let (p, all) =
    levels n reps tg strict iset (Stdlib.Int.succ k) k ((m0, bk0), (r :: []))
  in
  let (m, _) = p in
  map (fun t0 -> (t0, (match llook reps m t0 with
                       | Some b -> b
                       | None -> 0)))
    all

(** val set_okb :
    int -> int list list -> col list -> int list -> (cond -> bool) -> ((lC,
    lF) sst * int) list -> int -> bool **)

let set_okb n reps tg strict iset =
  let w = length reps in
  (fun v k ->
  (&&)
    ((&&)
      ((&&)
        ((&&)
          ((&&)
            ((&&)
              ((&&) ((&&) (Nat.ltb 0 w) (reps_okb n reps)) (tg_okb n reps tg))
              (tdist_okb n tg))
            (strict_okb n reps strict))
          (sym_okb iset))
        ((<=) (Stdlib.Int.succ 0) n))
      (forallb (pi_okb n reps) (lperms n reps)))
    (lcert n reps tg strict iset v k))

(** val iset_of : bool -> cond -> bool **)

let iset_of = function
| true -> cond_inI1
| false -> cond_inI0

(** val scert3 : bool -> int -> ((lC, lF) sst * int) list **)

let scert3 i1 k =
  ssearch (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0))) reps3 tg3
    strict3 (iset_of i1) k

(** val sok3 : bool -> int -> ((lC, lF) sst * int) list -> bool **)

let sok3 i1 k v =
  set_okb (Stdlib.Int.succ (Stdlib.Int.succ (Stdlib.Int.succ 0))) reps3 tg3
    strict3 (iset_of i1) v k
