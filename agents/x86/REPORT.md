# x86 report — instruction semantics trust link (round 1, 2026-10-24)

Owner: `x86`. Machine: AMD EPYC 9654 (Zen 4), Linux 5.15, gcc 11.4, GNU as (Intel syntax).
Model under test: `shared/MODEL.md` v1 §1 + §4.4 (flags), `agents/lean/SortProof/{Machine,X86}.lean`.

## 0. Result in one paragraph
Our abstract semantics for mov / cmp / cmovl / cmovg / cmovle / cmovge (32-bit register forms) agrees with
(a) the real CPU, (b) the ACL2 x86isa formal model (clause by clause, and an executable transcription run on
hardware vectors), (c) the Sail x86 model (clause reading), (d) the Lean x86 layer `X86.lean`.
Total real-CPU runs: 374.4 M program runs on 45 team programs (n <= 5) + 23.8 M runs on 3000 random I1 programs.
Semantic mismatches (all 64-bit registers + CF PF AF ZF SF OF + output slots): **0**. Negative controls detect errors.
Every AlphaDev program (repo + Supplement G, sort3..8) and both `upper` I0 sort5 programs sort on hardware under the
STRICT model (random garbage in scratch registers, in the upper 32 bits of every register, and in the flags).

## 1. Opcodes: SDM text, formal clause, our clause, evidence

Notation: all operands are 32-bit general registers (`r32`). Intel order `op D, S`. 64-bit mode.
`ZF SF OF CF` are RFLAGS bits. Our flag abstraction: one value in {lt, eq, gt}
(`MODEL.md` §1 `lt/gt`; §4.4 `(zf, lt)`; Lean `XState.flagOrd`).

### 1.1 MOV r32, r32 (89 /r as emitted by GNU as)
- SDM (Vol. 2B, MOV; Vol. 1 §3.4.1.1): "Copies the second operand (source operand) to the first operand (destination
  operand)." Flags affected: none. Vol. 1 §3.4.1.1: "32-bit operands generate a 32-bit result, zero-extended to a
  64-bit result in the destination general-purpose register."
- ACL2 x86isa (`machine/instructions/move.lisp` `x86-mov-Op/En-MR`): `x86-operand-to-reg/mem` -> `!rgfi-size 4` ->
  `wr32` = `(!rgfi reg (n32 val))` (`register-readers-and-writers.lisp`): zero-extends. Flags not touched.
- Sail x86 (`model/` translated from x86isa): same (`write_rgfi_size` -> `wr32`).
- Our model: `D := S`. Lean: `xstep (.mov d s)` = `upd regs d (regs s)` on `BitVec 32`.
- Evidence: `logs/opcode_tests.log` "mov r32,r32 ... PASS" (1.28 M runs, all 64 flag combinations; upper half cleared;
  flags unchanged). Also `mov m32, r32` / `mov r32, m32` (AlphaDev loads/stores) in all `model=mem` runs.

### 1.2 CMP r32, r32 (39 /r)
- SDM (Vol. 2A, CMP): "Compares the first source operand with the second source operand and sets the status flags in
  the EFLAGS register according to the results. The comparison is performed by subtracting the second operand from the
  first operand and then setting the status flags in the same manner as the SUB instruction." Flags: CF, OF, SF, ZF,
  AF, PF set according to the result. No register written.
- ACL2 x86isa (`instructions/arith-and-logic.lisp`, `*OP-CMP*`: "CMP and TEST modify just the flags";
  `instructions/sub-spec.lisp` `gpr-sub-spec-4`): `signed-raw = i32(dst) - i32(src)`, `result = n32(signed-raw)`,
  `cf = (dst <u src)`, `zf = (result = 0)`, `sf = result[31]`, `of = not (signed-byte-p 32 signed-raw)`,
  `pf` = even parity of result[7:0], `af = (dst[3:0] - src[3:0] < 0)`.
- Sail x86: same clauses (generated from x86isa).
- Our model: `lt := (A < B)`, `gt := (A > B)` signed 32-bit (MODEL §1); §4.4: `zf := (A == B)`, `lt := (A < B)`.
  Lean: `xcmp` (CF ZF SF OF as above) and theorem `xcmp_flagOrd`: flag order = `compare a.toInt b.toInt`.
- Equal values: ZF = 1, SF = OF, so l = g = false, le = ge = true. Upper 32 bits are ignored.
- Evidence: `logs/opcode_tests.log`: 4 M operand pairs (extremes INT_MIN/INT_MAX, 2^31 +- 1, 2^32, 1/7 equal pairs,
  1/11 pairs with equal low halves and different upper halves): all six flags + setl/setg/setle/setge equal the
  signed 32-bit (and 64-bit for the r64 form) compare. 0 fail.

### 1.3 CMOVcc r32, r32 (0F 4C cmovl, 0F 4F cmovg, 0F 4E cmovle, 0F 4D cmovge)
- SDM (Vol. 2A, CMOVcc) condition table: CMOVL "less (SF != OF)"; CMOVG "greater (ZF = 0 and SF = OF)";
  CMOVLE "less or equal (ZF = 1 or SF != OF)"; CMOVGE "greater or equal (SF = OF)". Flags affected: none.
  Operation (SDM pseudocode):
  `temp := SRC; IF condition TRUE THEN DEST := temp; ELSE IF (OperandSize = 32 and IA-32e mode active) THEN DEST[63:32] := 0; FI;`
- ACL2 x86isa (`instructions/conditional.lisp`): `jcc/cmovcc/setcc-spec` low nibble `#xC` (SF != OF), `#xD`
  (SF = OF), `#xE` (ZF = 1 or SF != OF), `#xF` (ZF = 0 and SF = OF). `x86-cmovcc`: if true `!rgfi-size` (zero-extends);
  if false and operand-size 4 and 64-bit mode: write back `loghead 32` of the old value ("The pseudocode in the Intel
  manual says that the high 32 bits are zeroed ... even when the condition is false").
- Sail x86 (`model/conditional.sail` `x86_cmovcc`): same, but zero-extends on false in 64-bit OR compatibility mode.
  (Different from x86isa only in compatibility mode; not relevant for us.)
- Our model: `cmovl: if lt`, `cmovg: if gt`, `cmovle: if not gt`, `cmovge: if not lt`; else no change.
  Lean: `Cond.xeval` = the SDM table; theorem `xeval_eq`: each of the 4 conditions is a function of `flagOrd`.
- Evidence: `logs/opcode_tests.log`: each opcode, 32- and 64-bit forms, all 64 combinations of CF PF AF ZF SF OF
  (set with popfq), 20000 random (dst, src) per combination: result = SDM, flags unchanged. 0 fail.

### 1.4 The upper-32-bit subtlety (task 2)
- Fact (hardware, x86isa, Sail, SDM agree): a 32-bit CMOVcc with a FALSE condition still writes the destination: bits
  63:32 := 0, bits 31:0 unchanged. Hardware: 2.56 M false-condition runs, upper half cleared in 100 %. Also for
  `cmovl eax, eax`. The 64-bit form with a false condition leaves the register unchanged.
- Does it matter for our model? **No**, for these reasons: (1) every program uses only 32-bit forms; (2) every
  32-bit read (mov, cmp, cmov source) reads only bits 31:0; (3) so bits 63:32 never reach an output or a flag.
  The model and Lean use 32-bit registers, and this is exact for the 32-bit projection. Hardware check: the harness
  puts random upper halves in every register and checks the full 64-bit result against a simulator that clears
  them (0 mismatches in 398 M runs).
- It WOULD matter if a program mixed a 32-bit cmov with a 64-bit read of the same register (out of model), or if a
  program used 64-bit forms for 32-bit data (then the sort is on int64, a different specification).
- Related: CMOVcc with a MEMORY source reads the source even when the condition is false (fault on an unreadable page:
  `logs/opcode_tests.log`). Our model has register sources only, so this is out of scope. AlphaDev uses memory only
  in `mov`.

### 1.5 Flag abstraction is exact for I1
The 4 conditions depend only on ZF and (SF xor OF). The 4 combinations give 3 classes: (SF != OF, any ZF) -> lt,
(SF = OF, ZF = 1) -> eq, (SF = OF, ZF = 0) -> gt. The state ZF = 1 and SF != OF (not reachable by cmp, reachable by
popf) acts as lt for all four conditions. So {lt, eq, gt} is exact; the 4th judge state (zf=1, lt=1) is redundant but
harmless. Hardware: exhaustive 64-combination test above. Lean: `xeval_eq`. This is FALSE for cmove/cmovne
(they need ZF alone) — only relevant for a future I2.

## 2. Real-CPU harness (task 1)

Files: `src/gen_harness.py` (model .s -> GNU as), `src/driver.c` (tests + independent C simulator),
`run_harness.sh TAG PER_TYPE NRAND file.s ...`, `run_all.sh PER_TYPE NRAND JOBS`.
- Register map: P<i> -> model index i, S<j> -> n + j (S renamed densely; a pure renaming). Two code modes:
  `reg` = each model register is a real 64-bit GPR (rax rcx rdx rsi r8-r11 rbx rbp r12-r15; rdi = state pointer),
  body = program text with 32-bit register names; `spill` = model registers in memory, each instruction loads to
  eax/edx, runs the SAME opcode on registers, stores back 64 bits (keeps the zero-extension effect). R > 14 -> spill only.
  `mem` (added in round 1b) = P<i> are REAL memory cells, S<j> real GPRs; P operands are emitted as memory operands
  (`mov r32,m32`, `mov m32,r32`, `cmp m32,r32`, `cmp r32,m32`, `cmovcc r32,m32`). Used when x86-legal.
- `out j, S` (spec `model=out`) = real 32-bit store `mov dword [slot j], r32` (flags unchanged), as in AlphaDev.
- Inputs: every weak order type (13 / 75 / 541; 4683 / 47293 / 545835 for n = 6 / 7 / 8) x PER_TYPE value choices
  (random distinct values; extreme pool INT_MIN, INT_MIN+1, -2..2, INT_MAX-1, INT_MAX), then NRAND random inputs
  (random 32-bit; extreme pool; range -2..2 for many duplicates). Garbage: scratch = random 64-bit / INT_MAX / INT_MIN /
  copy of an input / 0 / extreme; upper 32 bits of every register random; flags CF PF AF ZF SF OF random (popfq).
  Relaxed model runs too (scratch = INT_MAX, flags = eq (ZF=1), inputs < INT_MAX).
- Per run: (1) semantic check: all registers (64 bit), 6 flags, output slots vs simulator; (2) sort check: output j =
  last `out j` else final Pj (low 32 bits) == sorted inputs, by value.

Results (`logs/all_*.log`, `run_all.sh 5000 3000000 4`; each program in reg AND spill mode):

| program set | n | L (mem) / k (out) | runs per mode | sem mismatch | sort fail (strict) |
|---|---|---|---|---|---|
| orig AlphaDev repo + SuppG, sort3 | 3 | 17, 17, 18, 19, 20 | 3.07 M | 0 | 0 |
| orig sort4 | 4 | 28, 28, 29, 30, 31 | 3.38 M | 0 | 0 |
| orig sort5 | 5 | 42 (SuppG), 43, 43, 44, 45 | 5.71 M | 0 | 0 |
| out (spec ad2out) sort3/4/5 | 3-5 | k = 11..14 / 20..23 / 32..33 | 3.1-5.7 M | 0 | 0 |
| upper `sort5_I0_L42_mem`, `sort5_I0_k32_out` (I0) | 5 | 42 / 32 | 5.71 M | 0 | 0 |
| x86 own extraction `programs/alphadev_sort{3,4,5}.s` | 3-5 | 17 / 28 / 43 | 3.1-5.7 M | 0 | 0 |
| orig sort6_57, sort7_76, sort8_91 (smoke, `logs/spec_smoke.log`) | 6-8 | 57 / 76 / 91 | 0.5-55 M | 0 | 0 |
| `programs/alphadev_sort{3,4,5,5_43}.s`, `human_sort{3,4,5}.s` (`logs/top_*.log`) | 3-5 | 17/28/42/43, 18/28/46 | 3.1-5.7 M | 0 | 0 |
| upper `sort4_memops_L26` (VARIANT: cmp/cmov read memory, MM-1 dropped), reg + mem + spill (`logs/upper2.log`) | 4 | 26 | 3.38 M | 0 | 0 |
| naive I0 (cmovle->cmovl, cmovge->cmovg) of REPO sort3 / sort4 / sort5 | 3-5 | 17 / 28 / 43 | 3-5.7 M | 0 | 112680 / **0** / 1012950 |
| naive I0 of SI G Sort3_17 / Sort4_28 / Sort5_42 (`logs/naiveI0_suppG.log`) | 3-5 | 17 / 28 / 42 | 0.5-1.6 M | 0 | **0** / **0** / fail |

- Verbatim AlphaDev C++ (inline asm from `sort_functions_test.cc`, memory form, compiled with g++): Sort3..Sort8
  3 M inputs each, 0 fail (`logs/verbatim.log`). Note: the released file does not compile with GCC (clobber names
  `"r8d"` etc.; GCC wants `"r8"`); I patched only the clobber lists.
- My extraction (`src/extract_alphadev.py`) of repo sort3/4/5 is identical to spec's `programs/orig/*_repo.s`.
- Judge comparison (`logs/judge_all.log`): `shared/judge.py --strict` verdict = harness verdict for every file.
- Strict-model claim: confirmed on hardware for all programs above: random scratch / upper-half / flag garbage does
  not change the output. Naive I0: repo sort3 and sort5 (42 and 43) fail; SI Sort3_17 and both sort4 programs sort (same as spec's claim).

Negative controls: all 45 single-instruction deletions of sort3/sort4 fail the sort check in both modes (`logs/mutants_delete.log`);
simulator bug `-DSIMBUG` (cmovle as cmovl) -> 3.3 M semantic mismatches in 2914 / 3000 random programs
(`logs/random_fuzz_SIMBUG.log`); transcription bug `XBUG=1` -> 150783 / 299858 vectors mismatch.

Random-program fuzz (`src/gen_random.py`, 3000 programs, n = 4, 6 scratch, length 40, all six opcodes, D = S allowed):
23.8 M runs (two seeds), 0 semantic mismatches (`logs/random_fuzz.log`, `logs/random_fuzz2.log`).

## 3. Formal x86 models (task 3)

- ACL2 x86isa (acl2/acl2 git HEAD 2026-10-24, `books/projects/x86isa`) and Sail x86 (`rems-project/sail-x86-from-acl2`)
  are cloned in `ext/` (read only). Clauses in §1 above.
- Running the certified ACL2 model was NOT possible this round: the session's permission policy blocked downloading
  and running SBCL + ACL2. To do it, the user must allow it (script ready: `ext_build_acl2.sh`, ~1-3 h on 4 cores;
  then run the programs with `x86isa/tools/execution`).
- Substitute: `src/x86isa_transcribe.py` = line-by-line Python transcription of the x86isa functions
  (`gpr-sub-spec-4`, `pf/af/zf/sf/of-spec32`, `jcc/cmovcc/setcc-spec`, `x86-cmovcc`, `wr32`, mov). Run on hardware
  vectors (input state, hardware output state): 299858 vectors (3000 random programs) + 152000 vectors
  (76 team program/mode pairs): **0 mismatches** (`logs/x86isa_transcribe_random.log`, `logs/x86isa_all.log`).
  Limit: a transcription is not the certified model; it checks that our reading of the clauses matches hardware.
- K-x86 (Dasgupta et al. PLDI 2019) and the Isabelle x86 semantics: not checked this round.

## 4. Comparison with MODEL.md and Lean

| item | MODEL.md v1 | Lean `X86.lean` | x86 (SDM / x86isa / CPU) | verdict |
|---|---|---|---|---|
| value width | signed 32-bit | `BitVec 32`, `toInt` | 32-bit forms; upper half zeroed by every write | match (32-bit projection exact) |
| cmp | lt=(A<B), gt=(A>B); §4.4 zf, lt | CF ZF SF OF of a-b | same | match |
| cmovl/g/le/ge | lt / gt / not gt / not lt | SDM table, `xeval_eq` | SDM table | match |
| cmov false | no change | no change (32-bit) | 32-bit: upper := 0 | match for 32-bit reads (§1.4) |
| flags initial (strict) | §4.4: 4 states | all CF ZF SF OF | any RFLAGS | match; 3 classes suffice (§1.5) |
| relaxed initial flags eq | lt = gt = false | `.eq` | ZF=1, SF=OF: a real state | sound |
| P as memory (model=mem) | P only in mov | P as registers | mov r32,m32 / m32,r32 same 32-bit copy | match (mem programs are a subset) |
| `out j, S` | free snapshot | not modelled | `mov m32, r32`, flags unchanged | match; Lean lacks `out` |
| cmov memory source | n/a | n/a | read even if false (can fault) | out of model |

## 5. Open points / next
1. Run the certified ACL2 x86isa (needs user permission) on the AlphaDev programs; or K-x86 / Isabelle.
2. Test on an Intel CPU too (this machine is AMD Zen 4). The SDM and AMD APM agree; still, one Intel run is cheap.
3. Add `out` to Lean `X86.lean` (lean) and define cmovle/cmovge explicitly in MODEL.md §1 (spec) — §4.4 has it.
4. Re-run `run_all.sh` on every new `programs/found/*` (the upper agent's programs): it takes ~5 min.
