import KProto.Measure
namespace KProto
open LeanReflect

def listCode : List Nat → Nat
  | [] => 1
  | a :: l => listCode l * 8 + a

def sigCode (s : Ordering × List Nat) : Nat := listCode s.2 * 4 + s.1.ctorIdx

def hcK2 (c : Ctx) (k : Key) : Nat :=
  let idx := List.range c.m
  let sgc := idx.map (fun i => sigCode (stateSig c k i))
  let usc := idx.map (fun i => listCode (usig c k i))
  clog2K (maxList (idx.map fun i =>
    dc (fun i' => usc.getD i' 0) (idx.filter fun i' => sgc.getD i' 0 == sgc.getD i 0)))
def hK2 (c : Ctx) (k : Key) : Nat := hcK2 c k + (undone c k).length
end KProto
namespace KProto
open LeanReflect
/-- zipped grouping, no `getD` -/
def hcK3 (c : Ctx) (k : Key) : Nat :=
  let idx := List.range c.m
  let ps := idx.map (fun i => (stateSig c k i, usig c k i))
  clog2K (maxList (ps.map fun p => dc id ((ps.filter fun q => q.1 == p.1).map (·.2))))
def hK3 (c : Ctx) (k : Key) : Nat := hcK3 c k + (undone c k).length
/-- zipped grouping on Nat codes -/
def hcK4 (c : Ctx) (k : Key) : Nat :=
  let idx := List.range c.m
  let ps := idx.map (fun i => (sigCode (stateSig c k i), listCode (usig c k i)))
  clog2K (maxList (ps.map fun p => dc id ((ps.filter fun q => q.1 == p.1).map (·.2))))
def hK4 (c : Ctx) (k : Key) : Nat := hcK4 c k + (undone c k).length
#eval ((succsK c3 I1 (rootK c3)).map (fun k => (hK c3 k, hK3 c3 k, hK4 c3 k))).all (fun t => t.1 == t.2.1 && t.1 == t.2.2)
end KProto
