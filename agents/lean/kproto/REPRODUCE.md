# Kernel-only sort3 (k <= 10) — how to reproduce (agents/lean/kproto)

Trust: Lean kernel only. `#print axioms` of `KProto.D3k10I1G.lower_bound_kernel_x86` and
`KProto.sort3_mm_optimal_kernel`: [propext, Classical.choice, Quot.sound].
The certificate (KProto/D3k10I1G/*.lean) is produced by untrusted code (`gen2`); `Data.lean` holds the 2215 canonical
states as Nat-coded trees, the `Mod*/NMod*` modules are `decide +kernel` checks of the verified checker on them.

1. `lake build gen2 KProto.KernelG` (core Lean 4.33.1; LeanReflect/ and SortProof/ are sha-recorded copies, LEANREFLECT_SHA256).
2. `.lake/build/bin/gen2 3 10 I1 4 1 KProto/D3k10I1G G`   (10 s; regenerates Data/Mod*/NMod*/Final)
3. `lake env lean -j 1 --tstack=1000000 KProto/D3k10I1G/Data.lean -o .lake/build/lib/lean/KProto/D3k10I1G/Data.olean`   (1 min)
4. `./run3.sh KProto/D3k10I1G k10h 24 0-23 0`   (640 modules, resumable; ~1.5 h on 24 cores, 3-14 GB per heavy module:
   if a module is killed (exit 137) rerun with fewer parallel jobs, e.g. `./run3.sh KProto/D3k10I1G k10r 6 0-5 0`)
   The last step of run3.sh builds Final.lean: `lower_bound_kernel(_x86)`.
5. `lake env lean ax10.lean` prints the statements and axioms.
Flags that matter: `-j 1 --tstack=...` and NUMA memory binding (tools/membind.py): system time otherwise dominates.
Total measured: ~640 modules, ~20 CPU-hours user + comparable system time on this loaded machine.
