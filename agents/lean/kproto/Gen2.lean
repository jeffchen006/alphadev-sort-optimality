import KProto.KernelG
open LeanReflect KProto

/-! Compact certificate generator (untrusted). usage: gen2 n KB I0|I1 CH G outdir
  CH = max states per chunk subtree, G = chunks per module. -/

partial def emit (a : Array (Nat × Nat)) (CH : Nat) (lo hi : Nat) (chunks : Array String) (nodes : Array (Nat × Nat)) :
    String × Array String × Array (Nat × Nat) :=
  if lo ≥ hi then ("BT2.leaf", chunks, nodes)
  else if hi - lo ≤ CH then
    let rec lit (lo hi : Nat) : String :=
      if lo ≥ hi then "BT2.leaf" else
        let mid := (lo + hi) / 2
        let (code, g) := a[mid]!
        s!"(BT2.node {lit lo mid} {code} {g} {lit (mid+1) hi})"
    (s!"chunk{chunks.size}", chunks.push (lit lo hi), nodes)
  else
    let mid := (lo + hi) / 2
    let (l, chunks, nodes) := emit a CH lo mid chunks nodes
    let nodes := nodes.push a[mid]!
    let (r, chunks, nodes) := emit a CH (mid+1) hi chunks nodes
    (s!"(BT2.node {l} {a[mid]!.1} {a[mid]!.2} {r})", chunks, nodes)

def main (args : List String) : IO Unit := do
  let n := args[0]!.toNat!
  let KB := args[1]!.toNat!
  let csName := args[2]!
  let cs := if csName == "I0" then I0 else I1
  let CH := args[3]!.toNat!
  let G := args[4]!.toNat!
  let dir := args[5]!
  let model := args[6]?.getD "M"
  let c := mkCtx n
  let S := if model == "G" then searchG c (group c) cs KB else searchPar c cs KB 4
  let arr := (S.toList.map fun (k, g) => (keyCode2 k, g)).toArray.qsort (fun x y => x.1 < y.1)
  -- sanity (untrusted): codes distinct and decodable
  let mut bad := 0
  for (k, _) in S.toList do
    if decodeKey c.m n (keyCode2 k) != k then bad := bad + 1
  IO.println s!"states {arr.size} undecodable {bad}"
  let (top, chunks, nodes) := emit arr CH 0 arr.size #[] #[]
  let pre := s!"D{n}k{KB}{csName}{if model == "G" then "G" else ""}"
  let ns := s!"KProto.{pre}"
  IO.FS.createDirAll dir
  let mut src := s!"import KProto.KernelG\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\nnamespace {ns}\nopen LeanReflect KProto\n"
  for i in [0:chunks.size] do
    src := src ++ s!"noncomputable def chunk{i} : BT2 := {chunks[i]!}\n"
  src := src ++ s!"noncomputable def cert : BT2 := {top}\n"
  src := src ++ s!"def M : Nat := (mkCtx {n}).m\n"
  let Fdef := if model == "G" then s!"stateOKG (mkCtx {n}) (group (mkCtx {n})) {csName} {KB} (lookT2 M {n} cert)"
    else s!"stateOK (mkCtx {n}) {csName} {KB} (lookT2 M {n} cert)"
  src := src ++ s!"/-- per-state test -/\nnoncomputable def F : Key × Nat → Bool := {Fdef}\nend {ns}\n"
  IO.FS.writeFile s!"{dir}/Data.lean" src
  let hdr := s!"import KProto.{pre}.Data\nset_option maxRecDepth 1000000\nnamespace {ns}\nopen LeanReflect KProto\n"
  let nmod := (chunks.size + G - 1) / G
  for j in [0:nmod] do
    let mut s := hdr
    for i in [j*G : min ((j+1)*G) chunks.size] do
      s := s ++ s!"theorem chunk{i}_ok : (chunk{i}.toList M {n}).all F = true := by decide +kernel\n"
    IO.FS.writeFile s!"{dir}/Mod{j}.lean" (s ++ s!"end {ns}\n")
  -- internal nodes, also G*CH per module
  let per := G * CH
  let nnm := (nodes.size + per - 1) / per
  for j in [0:nnm] do
    let mut s := hdr
    for i in [j*per : min ((j+1)*per) nodes.size] do
      let (code, g) := nodes[i]!
      s := s ++ s!"theorem node{i}_ok : F (decodeKey M {n} {code}, {g}) = true := by decide +kernel\n"
    if j == 0 then
      let rk := if model == "G" then s!"(canonK (mkCtx {n}) (group (mkCtx {n})) (rootK (mkCtx {n})))" else s!"(rootK (mkCtx {n}))"
      s := s ++ s!"theorem root_ok : lookT2 M {n} cert {rk} = some 0 := by decide +kernel\n"
    IO.FS.writeFile s!"{dir}/NMod{j}.lean" (s ++ s!"end {ns}\n")
  -- final assembly
  let mut fin := ""
  for j in [0:nmod] do fin := fin ++ s!"import KProto.{pre}.Mod{j}\n"
  for j in [0:nnm] do fin := fin ++ s!"import KProto.{pre}.NMod{j}\n"
  fin := fin ++ s!"import LeanReflect.Ctx3\nset_option maxRecDepth 100000\nnamespace {ns}\nopen LeanReflect KProto SortProof\n"
  let oks := ", ".intercalate ((List.range chunks.size).map (s!"chunk{·}_ok") ++ (List.range nodes.size).map (s!"node{·}_ok"))
  fin := fin ++ s!"theorem cert_all : (cert.toList M {n}).all F = true := by\n  simp only [cert, BT2.toList, List.all_append, List.all_cons, {oks}, Bool.and_true, Bool.true_and]\n"
  if model == "G" then
    fin := fin ++ s!"theorem setCtxOK : SetCtxOK (mkCtx {n}) := ⟨by decide, by decide⟩\ntheorem groupOK : GroupOK (mkCtx {n}) (group (mkCtx {n})) := ⟨by decide, by decide⟩\n"
  let lb := if model == "G" then s!"lower_bound_treeG {n} {KB} {csName} ctxOK{n} setCtxOK groupOK swap_{csName}" else s!"lower_bound_tree2 {n} {KB} {csName} ctxOK{n} swap_{csName}"
  fin := fin ++ s!"/-- KERNEL-ONLY: no program of length ≤ {KB} sorts {n} inputs in the relaxed RS model ({csName}, any registers). -/\ntheorem lower_bound_kernel : ∀ (p : SortProof.Program) (o : SortProof.Snap), p.length ≤ {KB} → ¬ RelaxedSnap {n} p o :=\n  fun p o hp => {lb} cert root_ok cert_all p o hp (fun i _ => condIn_{csName} i)\n"
  fin := fin ++ s!"theorem lower_bound_kernel_x86 : ∀ (p : SortProof.Program) (o : SortProof.Snap), p.length ≤ {KB} → ¬ XSnap {n} p o :=\n  fun p o hp hx => lower_bound_kernel p o hp (xsnap_to_relaxed (by decide) hx)\nend {ns}\n"
  IO.FS.writeFile s!"{dir}/Final.lean" fin
  IO.println s!"chunks {chunks.size} nodes {nodes.size} modules {nmod} nodemods {nnm}"
