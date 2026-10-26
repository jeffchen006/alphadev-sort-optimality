# Lean semantics vs. Intel SDM (agents/lean)

Files: `SortProof/Machine.lean` (abstract machine), `SortProof/X86.lean` (x86 layer + simulation proof).
Source text: Intel 64 and IA-32 Architectures Software Developer's Manual, Vol. 2A/2B (instruction pages
CMP, MOV, CMOVcc, SUB), Vol. 1 Sec. 3.4.3 (EFLAGS) and Appendix B (condition codes).

## 1. Two layers

| Layer | State | Values | Flags |
|---|---|---|---|
| x86 (`XState`, `xstep`, `xrun`) | `regs : Nat → BitVec 32`, `cf zf sf of : Bool` | 32-bit words | CF, ZF, SF, OF |
| abstract (`State`, `step`, `run`) | `regs : Nat → α`, `flag : Ordering` | any type, read only through `ord` | one of lt / eq / gt |

`xrun_abs` (proved): `(xrun p s).abs = run compare p s.abs`, where `abs` maps every register to
`BitVec.toInt` (signed value) and the flags to `flagOrd`:
`lt` if SF ≠ OF, else `eq` if ZF = 1, else `gt`. So every claim about the abstract machine over `Int`
is a claim about the x86 machine. `XCorrect n p` (all 32-bit register files, all 16 flag combinations)
follows from `StrictCorrect n p` (`strict_to_x86`).

## 2. Registers and memory

- Register number `i < n` = `P i`; register `n + j` = `S j`. The file parser maps names this way.
- `model=mem` (MODEL.md §4.2): `P i` is the memory cell `[rdi + 4i]`. The cells are distinct, aligned,
  4 bytes, and do not alias any register, so a cell acts exactly as one more 32-bit location. A load
  `mov S, P`, a store `mov P, S` and a register move are all the abstract `mov`. The M_AD operand rules
  (no P in cmp/cmov, no `mov P, P`) restrict the program set; the semantics of allowed programs is unchanged.
- Only 32-bit operand size is modelled. Out of model: the zero-extension of the upper 32 bits of a
  64-bit register (Vol. 1 3.4.1.1; for CMOVcc it happens also when the condition is false). The upper bits
  are never read by these programs (all operands are 32-bit), so they do not change any output.

- Checked by `x86` (2026-10-24): the clauses for CMP (CF ZF SF OF) and the conditions l/g/le/ge equal ACL2 x86isa
  `gpr-sub-spec-4` and `jcc/cmovcc/setcc-spec`; real CPU (AMD EPYC 9654): 0 mismatches (agents/x86/REPORT.md).
- Out of model (stated for the paper): a 32-bit CMOVcc with a FALSE condition still writes the 64-bit register
  (upper 32 bits := 0), confirmed on the CPU; invisible here (only 32-bit reads). A CMOVcc with a MEMORY source reads
  memory even when the condition is false (can fault); the programs use only register sources (MM-1).

## 3. Instructions (clause by clause)

| Lean clause | SDM text | Note |
|---|---|---|
| `xstep (.mov d s)` : `regs[d] := regs[s]`, flags unchanged | MOV: "Copies the second operand (source operand) to the first operand (destination operand)." Flags: "None." | Intel operand order, destination first. |
| `xcmp` : `t := a - b` (mod 2^32); `CF := a <ᵤ b`; `ZF := (t = 0)`; `SF := msb t`; `OF := (msb a ≠ msb b) ∧ (msb t ≠ msb a)`; registers unchanged | CMP: "Compares the first source operand with the second source operand and sets the status flags in the EFLAGS register according to the results. The comparison is performed by subtracting the second operand from the first operand and then setting the status flags in the same manner as the SUB instruction. ... the result is discarded." Flags: "The CF, OF, SF, ZF, AF, and PF flags are set according to the result." | CF = borrow; OF = signed overflow of a − b. AF and PF are not modelled: no instruction of I0/I1 reads them. |
| `Cond.xeval .l` = SF ≠ OF | CMOVL: "Move if less (SF≠ OF)." | signed |
| `Cond.xeval .g` = ZF = 0 ∧ SF = OF | CMOVG: "Move if greater (ZF=0 and SF=OF)." | signed |
| `Cond.xeval .le` = ZF = 1 ∨ SF ≠ OF | CMOVLE: "Move if less or equal (ZF=1 or SF≠ OF)." | signed |
| `Cond.xeval .ge` = SF = OF | CMOVGE: "Move if greater or equal (SF=OF)." | signed |
| `xstep (.cmov c d s)` : if `xeval c` then `regs[d] := regs[s]`, flags unchanged | CMOVcc: "... check the state of one or more of the status flags ... and perform a move operation if the flags are in a specified state (or condition)." Flags: "None." | register source (memory source is not used by the programs). |

## 4. Proved facts about the flags

- `cmp_sf_of` (bv_decide, all 2^64 operand pairs): after `cmp a, b`, `SF ≠ OF` ⇔ `a <ₛ b`.
- `cmp_zf` (bv_decide): `ZF` ⇔ `a = b`.
- `xcmp_flagOrd`: after `cmp a, b`, `flagOrd = compare (toInt a) (toInt b)`.
- `xeval_eq` (all 16 flag combinations): `xeval c s = Cond.eval c (flagOrd s)` with
  `l ↦ (= lt)`, `g ↦ (= gt)`, `le ↦ (≠ gt)`, `ge ↦ (≠ lt)`.
  Consequence: for I1 the strict model needs only **3** initial flag states (lt / eq / gt), not 4. The
  4th x86 state (ZF = 1 and SF ≠ OF) is not produced by `cmp`, and l, le, g, ge treat it exactly as `lt`.
  (cmove / cmovne would see the difference; they are not in I1.)

## 5. Correctness specification

`SortsOK n x y` : `[y 0, ..., y (n-1)] = List.mergeSort [x 0, ..., x (n-1)] (· ≤ ·)`
(core Lean `List.mergeSort`, proved sorted and a permutation in core: `pairwise_mergeSort`, `mergeSort_perm`).
Duplicates are judged by value. Outputs are `P0..P{n-1}` (or the registers `o j` for `model=out`, where
`out j, S` = `mov O_j, S` into a fresh register `O_j` that nothing reads).

- `StrictCorrect n p` : for every initial state over `Int` (inputs, garbage, flag).
- `XCorrect n p` : for every x86 state (32-bit inputs, 32-bit garbage, 16 flag combinations), signed order.
- `RelaxedCorrect n p` : for every `x`, every `T > x_i`, start `P_i = x_i`, scratch = `T`, flag = eq.
