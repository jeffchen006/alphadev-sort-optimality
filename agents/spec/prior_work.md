# Prior work: are AlphaDev sort3/sort4/sort5 kernels shortest?

Date of search: 2026-10-24. Style: ASD-STE100 (short sentences). Written by a spec sub-agent; corrections by spec marked CORRECTION.
Tags: **[PRIMARY]** = I read the primary source. **[CHECKED]** = I ran a check myself.
**UNVERIFIED** = I could not read the primary source.

## 0. Facts about the AlphaDev kernels (base data)

- Citation: Mankowitz et al., "Faster sorting algorithms discovered using deep
  reinforcement learning", Nature 618:257-263, 2023. DOI 10.1038/s41586-023-06004-9.
- Table 1a (Nature) **[PRIMARY]**: sort3 17 vs 18, sort4 28 vs 28, sort5 **42** vs 46.
- Public code: github.com/google-deepmind/alphadev, file `sort_functions_test.cc`
  **[PRIMARY, CHECKED]**. The README and the code give sort5 = **43**, not 42.
  - Sort3AlphaDev: 17 = 6 mem mov + 11 reg ops (2 mov, 3 cmp, 6 cmov). Uses cmovl, cmovg, cmovle.
  - Sort4AlphaDev: 28 = 8 mem mov + 20 reg ops. Uses cmovl, cmovge.
  - Sort5AlphaDev: 43 = 10 mem mov + 33 reg ops. Uses cmovl, cmovg, cmovle.
  - Registers used: n+1 (3+1, 4+1, 5+1). So each kernel uses **one** scratch register.
  - I simulated all three on all inputs in {0..n-1}^n (all weak orders, ties included).
    All three are correct. Compares are signed 32-bit (cmovl/cmovg = signed).
- Kutenin, blog "Changing std::sort at Google's Scale and Beyond", danlark.org, 2022-04-20
  **[PRIMARY, via fetch]**: says sort3 18->17, sort5 **46->43**. No optimality claim.
- CORRECTION (spec): a 42-instruction sort5 IS public: Supplementary Information App. G, `Sort5_42`
  (static-content.springer.com .../41586_2023_6004_MOESM1_ESM.pdf, p. 23) **[PRIMARY, CHECKED]**. It passes the
  judge (relaxed + strict) and real x86: `programs/alphadev_sort5.s`. The repo / libc++ use the 43 one (main text:
  "For sort 5, we used a 43 length algorithm"). So 17/28/42 is right.
- Register note (spec): "n+1 registers" = n+1 x86 registers besides the n memory cells. In the register model
  M_out (MODEL §4.3) the loads are renamed away, so this is n registers + 1 scratch.
- AlphaDev search rules (Methods) **[PRIMARY]**: memory read in order; registers allocated in order;
  no cmp/cmov on memory; each memory location read once and written once; no uninitialised registers.
- AlphaDev "Brute-force approach" (sort3 >= 17, ~10^32 programs, >3 days): known, no certificate.

## 1. Ullrich & Hack, "Synthesis of Sorting Kernels" (main prior work)

- Citation: Marcel Ullrich, Sebastian Hack (Saarland University). CGO 2025 (Las Vegas,
  2025-03-03), pp. 1-14, DOI 10.1145/3696443.3708954. Distinguished Paper.
  Badges: Artifacts Available, Reusable, Results Reproduced.
  Preprint PDF: compilers.cs.uni-saarland.de/papers/ullrich_sorting_kernels.pdf **[PRIMARY, full text read]**.
  Artifact: Zenodo 10.5281/zenodo.14092980 (cgo25_artifact.zip); code github.com/NeuralCoder3/enumeration-synth (Rust).
  No arXiv version found.
- Model (Sec. 2.2-2.3):
  - Values start in registers r1..rn. Output must be in r1..rn. **No loads/stores counted.**
  - Scratch registers s1..sm. The paper text does not state m. The search-space formula
    (4(n+m)^2)^l matches the table only for **m = 1**. The code has `const SWAPS: usize = 1`
    (comment: SWAPS=2 used only for n=6). So all results are for **exactly 1 scratch register**.
  - Instructions: mov, cmp, cmovl, cmovg only. No cmovle/cmovge.
  - Correctness test: all n! permutations of 1..n (distinct values only). **Ties are not tested.**
    The paper argues that ties do not matter. This is not proved in the paper.
  - The 0-1 principle is not used (they note it does not hold for split cmp/cmov code).
- Results (register-only counts; add 2n for loads/stores):
  - n=3: optimal length **11** (= 17 with mem). All 5602 optimal programs enumerated
    (33612 before symmetry reduction; 23 distinct instruction multisets). Dijkstra/A*, no cut.
    Also CP (MiniZinc/Chuffed) enumerates all; SMT-Perm (z3) finds one in 44 min.
  - n=4: optimal length **20** (= 28 with mem). Lower bound: exhaustive search of length 19
    with no cut (k = infinity), **2 weeks**, no solution. Upper bound: 2,233,360 optimal
    programs, 63 distinct instruction multisets; the 20-instruction kernel equals 5 compare-swaps
    (the standard optimal network). Claimed as "new tight lower bound".
  - n=5: kernels of length ~**33** (= 43 with mem) found in 11 min with the non-optimality-preserving
    cut k=1. The table says "≈ 33". **No lower bound proved for n=5.**
  - n=6: ~45 (estimate only).
  - Min/max (SSE pminud/pmaxud, movdqa) variant: 8, 15, 26 for n=3,4,5 (networks: 9, 15, 27).
    They say minimality is verified for n=3 and n=4 only.
  - Other tools: SMT, CEGIS, SyGuS (cvc5), MetaLift, Gurobi/CBC ILP, PDDL planners, STOKE:
    none solves n=4. STOKE fails even for n=3.
- Kind of evidence: **exhaustive-search claim, no certificate.** The proof is a run of
  custom Rust code with hashing-based deduplication and symmetry rules
  (cmp only with i<j; "read registers in incremental order"; state dedup by sorted hash).
  No proof log. No independent checker. Soundness of each pruning rule is argued in prose only.
- Fit to the AlphaDev model:
  - Their n=3 bound 11 (+6) = 17 and n=4 bound 20 (+8) = 28 match AlphaDev, but only if
    (a) loads/stores are a fixed +2n, (b) m = 1, (c) distinct-input correctness.
  - Distinct-input correctness is weaker than tie-correctness, so their bound transfers to tie-correct
    programs **in I0 (no cmovle/cmovge), m = 1, outputs fixed in r1..rn at the end**. CORRECTION (spec): it does
    NOT transfer to I1: "cmovle = cmovl on distinct inputs" is false, because a cmp of two registers that hold
    copies of one input (or two scratch values) gives eq (MODEL §4.4).
  - Their output rule (outputs in r1..rn at the end) is more restrictive than AlphaDev's (store from any register
    at any time; MODEL §4.3 M_out). A lower bound in a MORE restrictive model excludes FEWER programs, so it is not
    an AlphaDev lower bound. Three gaps: m = 1, I0, fixed outputs.
  - Their bound does not cover m >= 2 scratch registers, memory used as scratch, or
    interleaving of loads/stores that save register moves.

## 2. Responses to AlphaDev (blogs, notes)

- Cassio Neri, "Shorter and faster than Sort3AlphaDev", arXiv:2307.14503, 2023-07-23 **[PRIMARY]**.
  - Sort3_14: 14 x86-64 instructions with a loop (branches). Sort3_15: 15 instructions, branchless,
    uses sbb/adc/movsb and a lookup table with indexed stores.
  - Both use instructions outside {mov, cmp, cmovX}. They refute the AlphaDev claim only if the
    ISA is "any x86". They do not refute it in the mov/cmp/cmov model.
  - Also: plain C++ sort3 faster than Sort3AlphaDev (1.06x-1.29x). Empirical only.
- Justine Tunney, "Understanding DeepMind's Sorting Algorithm", justine.lol/sorting, 2023-06-12
  **[PRIMARY via web.archive.org, read by spec; copy agents/spec/ext/web/justine.txt]**.
  - x86-64 sort3 = 3 compare-and-swap blocks (mov, cmp, cmovl, cmovl), 18 instructions; she shows the AlphaDev
    deletion of one mov ("wrekt by AlphaDev") gives 17. Transcribed: `programs/variants/tunney_sort3_17.s`, judge
    --strict PASS (I1: it uses cmovge; with cmovge->cmovg it fails).
  - "There's still two more mov instructions ... we could potentially shave away", shown only with ARM64 `csel`
    (3-operand select): 14 instructions. Outside the x86 mov/cmp/cmov model. No proof, no x86 kernel < 17.
- Hacker News claims of a shorter cmov sort3: DROPPED (no primary source found by two searches).
- Mimicry, "Faster Sorting Beyond DeepMind's AlphaDev", 2023, mimicry.ai/faster-sorting-beyond-deepminds-alphadev
  **[PRIMARY via web.archive.org; copy agents/spec/ext/web/mimicry.txt]**. Shuffle-index approach: SIMD sort3 in 9
  instructions; scalar sort3 17 (signed) with indexed stores; scalar sort4 27 (signed) / 23 (unsigned). These use
  instructions outside {mov, cmp, cmovX} (index arithmetic / addressing-mode stores, SIMD shuffles), so they do NOT
  refute AlphaDev in its model. Speed claims only; no optimality claim. Ullrich & Hack's table lists Mimicry sort3
  with 0 cmov and 8-9 "other" instructions (agents/spec/ext/ullrich/uh.txt lines 622, 635).

## 3. Superoptimizers

- Massalin, "Superoptimizer", ASPLOS 1987; GNU superopt (Granlund-Kenner, PLDI 1992):
  exhaustive, about 5 instructions max; no cmov in GNU superopt x86 target. No sort3 result found.
- STOKE: Schkufza, Sharma, Aiken, "Stochastic Superoptimization", ASPLOS 2013, arXiv:1211.0557
  **[PRIMARY, grep]**: benchmarks are Hacker's Delight, Montgomery mult., etc. No sort kernel.
  Ullrich-Hack ran STOKE on sort3: it fails (cold and warm start).
- Lens: Phothilimthana et al., "Scaling up Superoptimization", ASPLOS 2016, DOI 10.1145/2872362.2872387
  **[PRIMARY, grep]**: no sort benchmark.
- Denali (Joshi, Nelson, Randall, PLDI 2002), Souper (Sasnauskas et al., arXiv:1711.04422):
  no sort kernel result found (abstract and evaluation sections only; Ullrich & Hack, who survey them, report none).
- Brahma / Gulwani et al., "Synthesis of loop-free programs", PLDI 2011: component-based SMT
  synthesis; Ullrich-Hack's SMT baselines follow it. No sort kernel result.
- Conclusion: no superoptimizer paper claims an optimal sort3/4/5 cmov kernel.

## 4. Sorting-network optimality (comparator model, not instruction count)

- Codish, Cruz-Filipe, Frank, Schneider-Kamp, "Sorting nine inputs requires twenty-five comparisons",
  J. Comput. Syst. Sci. 82(3):551-563, 2016, DOI 10.1016/j.jcss.2015.11.014; preprint arXiv:1405.5754.
  s(9)=25, s(10)=29. SAT + symmetry (generate-and-prune). Computer-assisted proof.
- Cruz-Filipe, Larsen, Schneider-Kamp, "Formally Proving Size Optimality of Sorting Networks",
  J. Automated Reasoning 59(4):425-454, 2017. Coq-verified checker of an untrusted oracle
  certificate for n <= 9. This is a **certificate-checked** proof, comparator model only.
- Harder, "An Answer to the Bose-Nelson Sorting Problem for 11 and 12 Channels", arXiv:2012.04400
  (2020, rev. 2022). s(11)=35, s(12)=39. Certificate checked by an Isabelle/HOL-verified checker.
- Known small values: s(3)=3, s(4)=5, s(5)=9.
- Model gap: these count comparators (compare-exchange as one atomic op). The 0-1 principle holds.
  They do not bound mov/cmp/cmov counts. AlphaDev sort3 (17 < 18) and sort5 (43 < 46) show the
  instruction model differs from 4 x comparators: a cmp can feed cmovs that are not a full swap.

## 5. Formal verification and libc++

- Lean/Coq/Isabelle proof of AlphaDev kernel correctness or of a cmov-sort length lower bound:
  **none found** (searches 2023-2026). Correctness is only tested (AlphaDev test file; my simulation).
- LLVM D118029, "Introduce branchless sorting functions for sort3, sort4 and sort5", author Marco Gelmi,
  submitted 2022-01-24, accepted by ldionne 2022-04-06, landed 2022-04-08 as
  rG194d1965d2c8 (194d1965d2c841fa81e107d19e27fae1467e7f11) **[PRIMARY, Phabricator]**.
  Adds `__sort3/4/5_maybe_branchless`, `__cond_swap`, `__partially_sorted_swap` in
  libcxx/include/__algorithm/sort.h. C++ ternaries that compile to cmov. Gated to contiguous
  iterators, arithmetic types <= pointer size, std::less/greater. Text says "generated using
  Reinforcement Learning". No instruction counts, no optimality claim. Accepted on benchmarks.

## 6. The real gap

What is still **not** proved with a checkable certificate:

1. **sort3 >= 17 and sort4 >= 28 with a certificate.** Two independent exhaustive searches exist
   (AlphaDev 3 days; Ullrich-Hack). Neither gives a proof log or a verified checker.
2. **sort5 lower bound.** Nobody proved sort5 >= 42 (32 register ops) in any model. (The 42 program is
   public: SI App. G Sort5_42.)
3. **Precise model.** No result states and covers this model in full:
   - ISA {mov, cmp, cmovl, cmovle, cmovg, cmovge}, signed 32-bit compare;
   - loads/stores counted (each memory cell read once, written once, or free reuse?);
   - correctness on all inputs **with ties**;
   - **unbounded** scratch registers (Ullrich-Hack fix m = 1; AlphaDev bound is unclear);
   - outputs stored from any register at any time (AlphaDev) — Ullrich-Hack fix outputs in r1..rn at the end;
   The m = 1 restriction is the biggest hole: a shorter kernel with 2+ scratch registers is
   not excluded by any published search.
4. **Soundness of symmetry and dedup rules** (register renaming, cmp operand order, flag
   overwrite, "registers read in increasing order") is argued in prose, not proved.

A checkable result would be: for each n in {3,4,5}, a precise model statement, plus a
certificate (for example SAT UNSAT proof in DRAT/LRAT for length L-1, or a Lean/Coq proof)
that no program of length L-1 exists for any number of scratch registers (with a proof that
k scratch registers suffice, e.g. k <= L), checked by a verified checker.
