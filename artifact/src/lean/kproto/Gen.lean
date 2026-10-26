import KProto.Kernel
open LeanReflect KProto

/-! Certificate generator (untrusted): runs lean-reflect's `search`, writes a chunked tree certificate.
  usage: gen n KB I0|I1 CH outdir   (CH = max states per chunk module) -/

instance : Inhabited Key := ⟨{ cols := [], flag := [], done := [] }⟩

def ordS : Ordering → String
  | .lt => ".lt" | .eq => ".eq" | .gt => ".gt"

def keyS (k : Key) : String :=
  let cols := ", ".intercalate (k.cols.map fun col => "[" ++ ", ".intercalate (col.map toString) ++ "]")
  let fl := ", ".intercalate (k.flag.map ordS)
  let dn := ", ".intercalate (k.done.map toString)
  "{ cols := [" ++ cols ++ "], flag := [" ++ fl ++ "], done := [" ++ dn ++ "] }"

/-- Emit a balanced tree over `a[lo:hi]`; subtrees with ≤ CH entries become chunk definitions. -/
partial def emit (a : Array (Nat × Key × Nat)) (CH : Nat) (lo hi : Nat)
    (chunks : Array String) (nodes : Array String) : String × Array String × Array String :=
  if lo ≥ hi then ("BT.leaf", chunks, nodes)
  else if hi - lo ≤ CH then
    let rec lit (lo hi : Nat) : String :=
      if lo ≥ hi then "BT.leaf" else
        let mid := (lo + hi) / 2
        let (code, k, g) := a[mid]!
        s!"(BT.node {lit lo mid} {code} {keyS k} {g} {lit (mid+1) hi})"
    let name := s!"chunk{chunks.size}"
    (name, chunks.push (lit lo hi), nodes)
  else
    let mid := (lo + hi) / 2
    let (code, k, g) := a[mid]!
    let (l, chunks, nodes) := emit a CH lo mid chunks nodes
    let nname := s!"node{nodes.size}"
    let nodes := nodes.push s!"({keyS k}, {g})"
    let (r, chunks, nodes) := emit a CH (mid+1) hi chunks nodes
    (s!"(BT.node {l} {code} {nname}.1 {nname}.2 {r})", chunks, nodes)

def main (args : List String) : IO Unit := do
  let n := args[0]!.toNat!
  let KB := args[1]!.toNat!
  let csName := args[2]!
  let cs := if csName == "I0" then I0 else I1
  let CH := args[3]!.toNat!
  let dir := args[4]!
  let c := mkCtx n
  let S := searchPar c cs KB 4
  let arr := (S.toList.map fun (k, g) => (keyCode k, k, g)).toArray.qsort (fun x y => x.1 < y.1)
  -- codes must be distinct for a clean tree (find re-checks the key anyway)
  IO.println s!"states {arr.size}"
  let (top, chunks, nodes) := emit arr CH 0 arr.size #[] #[]
  let pre := s!"n{n}k{KB}{csName}"
  IO.FS.createDirAll dir
  -- data module: nodes + chunks + tree
  let mut src := "import KProto.Kernel\nset_option maxRecDepth 100000\nnamespace KProto.C" ++ pre ++ "\nopen LeanReflect KProto\n"
  for i in [0:nodes.size] do
    src := src ++ s!"def node{i} : Key × Nat := {nodes[i]!}\n"
  for i in [0:chunks.size] do
    src := src ++ s!"def chunk{i} : BT := {chunks[i]!}\n"
  src := src ++ s!"def cert : BT := {top}\nend KProto.C{pre}\n"
  IO.FS.writeFile s!"{dir}/Data.lean" src
  -- one module per chunk
  let ctx := s!"(stateOK (mkCtx {n}) {csName} {KB} (lookT cert))"
  for i in [0:chunks.size] do
    IO.FS.writeFile s!"{dir}/Chunk{i}.lean" (
      s!"import KProto.C{pre}.Data\nset_option maxRecDepth 1000000\nnamespace KProto.C{pre}\nopen LeanReflect KProto\n" ++
      s!"theorem chunk{i}_ok : chunk{i}.toList.all {ctx} = true := by decide +kernel\nend KProto.C{pre}\n")
  -- nodes module
  let mut ns := s!"import KProto.C{pre}.Data\nset_option maxRecDepth 1000000\nnamespace KProto.C{pre}\nopen LeanReflect KProto\n"
  for i in [0:nodes.size] do
    ns := ns ++ s!"theorem node{i}_ok : {ctx} node{i} = true := by decide +kernel\n"
  ns := ns ++ s!"theorem root_ok : lookT cert (rootK (mkCtx {n})) = some 0 := by decide +kernel\nend KProto.C{pre}\n"
  IO.FS.writeFile s!"{dir}/Nodes.lean" ns
  IO.println s!"chunks {chunks.size} nodes {nodes.size}"
