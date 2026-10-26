# lean — round 3 report (2026-10-25) — DRAFT, run in progress

## Done
1. **Strict L5** (theory CERT_OBLIGATIONS): `SortProof/L5Strict.lean`, frozen/v3.
   `l5_sim` (the L5 translation is a simulation for every initial state), `l5_strict : MMProg n q → XCorrect n q →
   ∃ p o, |p| + 2n ≤ |q| ∧ opcodes kept ∧ XSnap n p o`, `mm_lower_bound_strict` (H : ∀ p o, |p| ≤ K → ¬ XSnap n p o).
   No sorry; axioms propext / Classical.choice / Quot.sound.
2. **Kernel-only checker** for lean-reflect's certificates (`agents/lean/kproto`, on sha-recorded COPIES of their files):
   `checkK` / `checkGK` = their `check` / `checkG` with insertion sort (= `List.mergeSort`, proved), `clog2` by fuel
   (proved), and a Nat-coded binary-tree lookup (`BT2.find` re-checks the full key, so soundness needs no BST
   invariant). Theorems `lower_bound_tree2`, `lower_bound_treeG` reuse their `check_sound` / `lower_bound_G`.
   Generator `gen2` writes the certificate as one data module + chunk modules (≤ 4 states each); `run3.sh` checks
   them with `lake env lean -j 1 --tstack` and NUMA memory binding (`tools/membind.py`); resumable.
3. **Kernel-only theorem, k ≤ 8**: `KProto.Cn3k8I1.lower_bound_kernel_x86 : ∀ p o, p.length ≤ 8 → ¬ XSnap 3 p o`,
   axioms [propext, Classical.choice, Quot.sound]. 1094 states, 45 CPU-min.

## Numbers (this machine, loaded, 4 cores)
- Kernel speed ≈ 1e4 simple steps/s; ≈ 1500× slower than the native checker; kernel cache memory grows inside one
  theorem (≈ 0.3-1.7 GB per state), so chunks must be small (≤ 4 states).
- System time: up to 6× the user time from page faults (NUMA balancing is on: 1.8e11 hint faults system-wide).
  Binding memory to one NUMA node (`set_mempolicy`) helps when the machine is quiet.
- `h` (H1 classes) is ~80% of the per-state time; Nat-coded signatures give only 1.4×.
- sort3 k ≤ 10 certificate sizes: multiset model 437,100 states (≈ 18 CPU-days in the kernel); set+S3 56,816 states
  (≈ 170 CPU-h); set+S3+H3' (lean-reflect, 23:41) **2,215 states** (≈ 640 modules × ~60 s ≈ 3 h on 4 cores).

## Running
- k ≤ 10 kernel run on the 2,215-state certificate (`kproto/KProto/D3k10I1G`, logs/k10h/progress.txt).

## Open
- sort4 kernel-only: out of reach with closure certificates (estimate ≥ 1e6 CPU-h); sort4 stays native_decide /
  cake_lpr.
