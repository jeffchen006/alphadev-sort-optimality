# x86 — round 1 report (2026-10-24)

## Done
1. Real-CPU harness (`agents/x86/run_harness.sh`, `run_all.sh`; `src/gen_harness.py` + `src/driver.c`). Each model
   program becomes x86-64 code in 2 modes (all model registers in real GPRs; or in memory with the same opcodes).
   Inputs: all weak order types x 5000 value sets + 3 M random (INT_MIN/INT_MAX, duplicates). Garbage in scratch
   registers, upper 32 bits and flags (popfq). Each run compares all 64-bit registers + 6 flags + out slots with an
   independent simulator, and checks the sort.
2. Opcode tests (`src/opcode_tests.c`): mov/cmp/cmovl/cmovg/cmovle/cmovge, 32 and 64 bit, all 64 flag combinations.
3. Formal models: ACL2 x86isa and Sail x86 clauses read and compared (`agents/x86/REPORT.md` §1); executable
   transcription of the x86isa clauses (`src/x86isa_transcribe.py`) checked against hardware vectors.
4. `agents/x86/REPORT.md`: per opcode SDM text, formal clause, our clause (MODEL.md, Lean X86.lean), evidence.

## Numbers (AMD EPYC 9654)
- 374 M runs on 45 team programs (n <= 5; programs/, orig/, out/, found/) + 24 M runs on 3000 random I1 programs:
  0 semantic mismatches. sort6/7/8 (orig): 0 mismatches, sort.
- Every AlphaDev program (repo + SI App. G, incl. Sort5_42), the human networks, and upper's I0 sort5
  (L = 42 mem / k = 32 out) sort on hardware in the STRICT model. judge.py --strict = hardware verdict, all files.
- Naive I0 (le->l, ge->g): repo Sort3 and sort5 (42, 43) fail; SI Sort3_17 and both Sort4_28 sort (agrees with spec).
- x86isa transcription vs hardware: 451858 vectors, 0 mismatches.
- Negative controls work: 45/45 deletion mutants fail; simulator bug -> 3.3 M mismatches; transcription bug -> 150783.
- 32-bit cmov with FALSE condition clears bits 63:32 (2.56 M runs; SDM, x86isa, Sail agree). Does not matter for our
  model: all forms are 32-bit, and no 32-bit read sees the upper half.
- Flag abstraction {lt, eq, gt} is exact for l/g/le/ge (all 64 flag combos); it is not for cmove/cmovne.
- Verbatim AlphaDev C++ asm: Sort3..8 pass 3 M inputs each. The released file needs a GCC clobber fix ("r8d" -> "r8").

## Open problems
1. Certified ACL2 x86isa run not done: the permission policy blocked download + build of SBCL/ACL2
   (`agents/x86/ext_build_acl2.sh` ready; needs user approval). K-x86 / Isabelle: not checked.
2. Only an AMD CPU was tested; no Intel CPU on this host.
3. Lean `X86.lean` has no `out j, S`; MODEL.md §1 does not define cmovle/cmovge (§4.4 does). Sent to lean, spec.

## Next
- Re-run `run_all.sh 5000 3000000 4` on each new `programs/found/*` (about 5 min).
- ACL2 x86isa run if the user allows it; Intel run if a host is available.
- MM-1-dropped variant (cmp/cmov with memory source): add opcode tests for `cmp r32, m32`, `cmovcc r32, m32` if a
  team member works on it.
