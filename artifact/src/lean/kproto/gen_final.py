#!/usr/bin/env python3
"""Write DIR/Final.lean: assemble chunk/node theorems into the kernel-only lower bound.
usage: gen_final.py DIR n KB I0|I1"""
import sys, re, os
D, n, KB, cs = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
pre = os.path.basename(D)          # e.g. Cn3k8I1
data = open(f'{D}/Data.lean').read()
nch = len(re.findall(r'^def chunk\d+ ', data, re.M))
nno = len(re.findall(r'^def node\d+ ', data, re.M))
imps = [f'import KProto.{pre}.Chunk{i}' for i in range(nch)] + [f'import KProto.{pre}.Nodes']
oks = ', '.join([f'chunk{i}_ok\'' for i in range(nch)] + [f'node{i}_ok\'' for i in range(nno)])
restate = '\n'.join([f"theorem chunk{i}_ok' : chunk{i}.toList.all F = true := chunk{i}_ok" for i in range(nch)] +
                     [f"theorem node{i}_ok' : F (node{i}.1, node{i}.2) = true := node{i}_ok" for i in range(nno)])
src = '\n'.join(imps) + f'''
import LeanReflect.Ctx3
set_option maxRecDepth 100000
namespace KProto.{pre}
open LeanReflect KProto SortProof

/-- The per-state test (kept folded so that `simp` unfolds only the tree shape of `cert`). -/
def F : Key × Nat → Bool := stateOK (mkCtx {n}) {cs} {KB} (lookT cert)
{restate}

theorem cert_all : cert.toList.all (stateOK (mkCtx {n}) {cs} {KB} (lookT cert)) = true := by
  show cert.toList.all F = true
  simp only [cert, BT.toList, List.all_append, List.all_cons, {oks}, Bool.and_true, Bool.true_and,
    List.all_nil]

/-- KERNEL-ONLY: no program of length ≤ {KB} sorts {n} inputs in the relaxed RS model ({cs}, any registers). -/
theorem lower_bound_kernel : ∀ (p : Program) (o : Snap), p.length ≤ {KB} → ¬ RelaxedSnap {n} p o :=
  fun p o hp => lower_bound_tree {n} {KB} {cs} ctxOK{n} swap_{cs} cert root_ok cert_all p o hp (fun i _ => condIn_{cs} i)

/-- x86 form. -/
theorem lower_bound_kernel_x86 : ∀ (p : Program) (o : Snap), p.length ≤ {KB} → ¬ XSnap {n} p o :=
  fun p o hp hx => lower_bound_kernel p o hp (xsnap_to_relaxed (by decide) hx)

end KProto.{pre}
'''
open(f'{D}/Final.lean', 'w').write(src)
print('chunks', nch, 'nodes', nno)
