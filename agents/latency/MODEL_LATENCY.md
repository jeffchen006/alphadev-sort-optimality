# Latency models (latency agent, v1 2026-10-24)

Base: `shared/MODEL.md` v0 (machine M(n, R, I), weak order types, relaxation T / eq flags).
This file adds a cost = latency. Length k = number of register instructions (no load/store).

## 1. Dependency DAG and critical path
A program is a sequence of instructions. Each instruction reads and writes these resources:

| instr | reads | writes |
|---|---|---|
| `mov D,S` | S | D |
| `cmp A,B` | A, B | flags |
| `cmovcc D,S` | D, S, flags (always, also when cc is false) | D |

- RAW edge i -> j: j reads a resource whose last writer before j is i.
- WAR and WAW edges do NOT count (register renaming renames GPRs and flags).
- Inputs (and garbage registers, initial flags) are ready at time 0.
- ready(j) = lat(j) + max over RAW predecessors of ready(i).
- depth(P) = max over the n outputs of ready(last writer of the output register).
  (An instruction that does not feed an output does not count. In a minimal program there is none.)
- Infinite issue width, infinite ports: this is the pure latency bound (critical path).
  Throughput is a separate model (sec. 5).

## 2. Latency tables (cycles), from uops.info (r32,r32 forms)

| uarch | mov r,r | cmp r,r (->flags) | cmovl/g/le/ge (data->dst) | cmov (flags->dst) | source |
|---|---|---|---|---|---|
| Skylake | 0 (eliminated; can fail -> 1) | 1 | 1 | 1 | uops.info MOV_89, CMP_39, CMOVL/CMOVLE_R32_R32 |
| Ice Lake | 1 (mov elim. disabled by microcode) | 1 | 1 | 1 | same |
| Alder Lake-P | 0 | 1 | 1 | 1 | same |
| Zen 2 | 0 | 1 | 1 | 2 (2 uops) | same |
| Zen 3 / Zen 4 | 0 | 1 | 1 | 1 | same |

This gives three abstract models. Load/store are not counted: a load adds the same
constant to every input, a store is not on a RAW chain to another instruction.

| model | mov | cmp | cmov | real CPUs |
|---|---|---|---|---|
| **U** (unit, no mov elimination) | 1 | 1 | 1 | Ice Lake; Skylake when elimination fails |
| **E** (mov elimination) | 0 | 1 | 1 | Skylake (ideal), Alder Lake-P, Zen 3, Zen 4 |
| **Z2** | 0 | 2 | 1 | Zen 2 (flags->cmov = 2 is the same as cmp = 2, because flags feed only cmovs) |

Model (a) of the brief ("unit latency per instruction") = U.

## 3. Output convention
- `free` (default here): output j may be in any register; distinct outputs in distinct registers.
  This is the AlphaDev memory form: the n stores choose the registers, the n loads choose free
  registers. AlphaDev length L = k + 2n (sort3: 17 = 11 + 6; sort4: 28 = 20 + 8).
- `fixed`: output j in Pj (shared/MODEL.md sec. 1). Can need extra movs.

## 4. How AlphaDev measured latency (paper + supplement; `spec` asked to confirm)
- Fixed sort3/4/5 were optimized for LENGTH, used as a proxy for latency
  (supp. App. B, Pearson(length, latency) = 1.00, 1.00, 0.98 for sort3, 4, 5).
- Latency (the real metric, used as reward for VarSort / VarInt / competitive) was measured,
  not modeled: CPU_CLK_UNHALTED.CORE, sort over 10,000 random inputs, 5th percentile of
  measurements, 10 machines during training, 100 machines for the final numbers
  (Methods, "Latency benchmarking suite").
- AlphaDev did NOT use a dependency-depth model. Our depth models are a new, exact objective.

## 5. Throughput (secondary, not yet searched)
Steady-state lower bound per call: max( uops / issue width, cmov uops / #cmov ports ).
Skylake: width 4, cmov on p06 (2 ports), mov eliminated = 0 executed uops.

## 6. Lower-bound relaxation for depth (relaxed DAG RD, used by `relax.py`)
RD has two node types, each latency 1: `cmp(a,b)` -> flag, `sel(f,a,b)` = b if f=lt else a.
No two-address rule, no single flags register, free copies, free sharing.
- Every real program in I0 or I1 maps to an RD DAG of depth <= its depth in U or E
  (cmovg = sel on swapped cmp; cmovle/cmovge = cmovg/cmovl with a, b swapped).
- Outputs are independent in RD (sharing is free): min depth = max over j of min depth(output j).
- Width bound: a layer-l node set never needs more nodes than a tree of root depth D has
  depth-l nodes (W_l in `relax.widths`). Nodes of equal function can merge. So the bounded-width
  encoding is complete for RD.
- Conversely (construction, `construct.py`): an RD DAG without T maps to a real I0 program with the
  SAME depth in U and in E: unroll to a tree, give every cmov its own copy of its D operand
  (`mov t, Pi` has depth 1 <= the depth of any flags, so it costs no depth), re-issue each cmp right
  before its cmov. So in U and E (free outputs, unbounded length and registers):
  **min depth(real) = min depth(RD without T)**, and RD with T is a lower bound.

## 7. Length at a given depth (joint relaxed DAG, `relax_joint.py`)
One RD DAG for all n outputs, with sharing. A sel node may test lt or gt of its flag node, so one real cmp
= one flag node. For a real program P of depth <= D (U, E; Z2 with cl = 2): distinct sel functions <= #cmov(P),
distinct non-constant flag functions (up to orientation) <= #cmp(P). So "no joint DAG with <= K nodes" gives
#cmp + #cmov >= K+1 and k >= K+1 for EVERY program of depth <= D (movs not counted, any length, R unbounded).
Width per layer = sum over outputs of the per-output tree bound. Used-node symmetry: used nodes first, sorted.
