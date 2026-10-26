# Review log (owner: critic). One section per claim. Verdict: confirmed / refuted / insufficient.
Own tools: `agents/critic/asmcheck.py` (AT&T simulator for the DeepMind repo file), `agents/critic/progcheck.py`
(MODEL §5 files, strict: all weak orders × garbage set × 3 initial flags), `agents/critic/bf.cpp` (own IDDFS brute force).

## R1. spec: AlphaDev lengths and instruction set
- Claim: repo lengths 17/28/43, paper Table 1a 17/28/42; SI App. G has Sort5_42.
- Re-ran: `python3 agents/critic/asmcheck.py` (repo file); `progcheck.py` on `programs/alphadev_sort3.s`, `programs/orig/alphadev_sort3_17_suppG.s`, `programs/orig/alphadev_sort4_28_repo.s`, `programs/alphadev_sort5.s`.
- Verdict: **confirmed**. All four correct (strict). 42-instruction sort5 exists (SI version), counts {mov 15, cmp 9, cmov 18}.
- Note: no single instruction is removable from repo sort3/4/5.

## R2. spec "SI Sort3_17 and Sort4_28 still sort after cmovle->cmovl, cmovge->cmovg; sort5 42/43 do not"
- Re-ran: `sed 's/cmovle/cmovl/;s/cmovge/cmovg/'` + `progcheck.py`.
- Verdict: **confirmed**, with a precision: the **repo** Sort3AlphaDev (`programs/alphadev_sort3.s`) FAILS after le->l (207 of 2691 tests). The SI App. G Sort3_17 passes. So "AlphaDev sort3 is not I0" (my claim) holds for the repo program only; an I0 program of length 17 exists. Main claim still needs I1 (AlphaDev action space; sort5).

## R3. critic TIP "permutations + I0 relaxes weak orders + I1"
- Verdict: **refuted** (by spec and theory, and I agree): cmp of two copies of one input, or T vs T, gives eq on permutations. Sound: permutations + I1 (L1b).

## R4. bounds: sort5 in I0 with 7 cmp (agents/bounds/fj5_7cmp.s)
- Re-ran: `python3 agents/critic/progcheck.py agents/bounds/fj5_7cmp.s` → 72 instr, 7 cmp, 0 fails.
- Verdict: **confirmed**. So "#cmp >= 9" (network size) is not a sound bound. "#cmp >= ceil(log2 n!)" is sound (each cmp gives one bit on permutations, the output permutation is a function of the cmp outcomes).

## R5. MODEL.md v0 §1 fixed outputs (RF)
- Verdict: **refuted as a lower-bound model** (critic, theory, spec agree). theory/check.py: AlphaDev cores are correct in RE/RS, not RF (sort3_17 outputs end in (P0,S11,P1)). Use RS (snapshot). MODEL.md must be bumped.

## R6. theory lemmas.md v1 (L1–L6, chain theorem)
- Read in full. Verdict: **confirmed with remarks** (see agents/critic/REVIEW_theory.md for details).

## R7. upper: sort5 in I0 with L=42 (k_out=32)
- Re-ran: `python3 agents/critic/progcheck.py programs/found/upper_sort5_I0_L42_mem.s` and `..._k32_out.s`; grep: 0 cmp/cmov on P, 5 loads, 5 stores.
- Verdict: **confirmed**. k_out^{I0}(5) <= 32. So I0 and I1 have the same AlphaDev-length witnesses for n=3,4,5.

## R8. spec: judge = real x86 (xdiff)
- Re-ran smaller instance: `python3 agents/spec/x86/xdiff.py --edge` → 1600 cases, 0 mismatches. Full program run not re-run (CPU quota).
- Verdict: **confirmed (edge part)**; program part: insufficient (not re-run by me).

## R9. spec: programs/out/* (ad2out map) correct with k <= L-2n
- Re-ran own progcheck (supports `out j, R`) on all n<=5 files: all correct; k: sort3 11/11/12/13/14, sort4 20/20/20/22/23, sort5 32/33/33/33/33.
- Verdict: **confirmed**. No file has k below the targets 11/20/32.

## R10. enum_out.cpp heuristic (code read; PRUNING.md not yet written)
- h = h_c + h_m. h_c = ceil(log2(largest class of permutations with equal index content + flags)): sound by the class-split argument (critic claim, #cmp >= log2 n!). h_m = max(#missing targets, max_j cover(j) − 1): sound (support of a cmov result ⊆ union of supports). needMask dead-state test: sound (values are only copied).
- Verdict: **looks sound**; final verdict after PRUNING.md (set model "Lemma S", rules E1–E4).

## R11. x86: flag abstraction exact for l/g/le/ge; cmov32 semantics
- Re-ran: compiled agents/x86/src/opcode_tests.c into my scratch dir and ran it: ALL OPCODE TESTS PASS.
- Verdict: **confirmed**. The 338 M-run program fuzz (run_all.sh) not re-run (quota); hardware vs judge agreement taken from x86 logs: insufficient by my own re-run, but consistent with R8.

## R12. theory L7: #cmp >= ceil(log2 n!)
- Same argument as my proof sketch (equal flag history ⇒ equal labels ⇒ binary split). Verdict: **confirmed**.

## R13. critic: n=3 RS I0 minimum k = 11
- Ran: `./bf 3 snapshot I0 11 hplus` (agents/critic/logs/n3_snapshot_I0.log): UNSAT k=0..10, SAT k=11 (1.4e9 nodes, 1404 s at k=11).
- Witness converted by bf2prog.py, checked strict by own progcheck.py and by shared/judge.py: correct. The SAT at the known optimum is a sanity check that the pruning does not cut the optimum.
- Verdict (self-claim, needs a second tool): sat/sat2/enum must reproduce "I0 RS n=3: none <= 10".

## R14. critic: n=3 RS I1 — no program with k <= 10
- Ran: `./bf 3 snapshot I1 11 hplus`: UNSAT k=0..10 (k=10: 1.73e9 nodes, 1577 s). k=11 SAT search still running (witness known: programs/out/alphadev_sort3_17_repo_out.s).
- Verdict (self-claim): sort3 bronze target holds in my tool. Must be reproduced by sat/sat2/enum with certificates.

## R15. enum: n=3 M_out none <= 10 (I1, I0)
- Re-ran: built enum_out.cpp in my scratch, `enum_out 3 1 1 10 2 1` (I1) and `... 3 1 0 10 2 1` (I0): RESULT none<=10 both.
- My bf.cpp (different design: register multiset IDDFS, not set model) gives the same. Verdict: **confirmed**.

## R16. enum PRUNING.md v1 (review of joint soundness)
- Lemma S (set model = register model): potential argument checked case by case (mov: Φ+1; cmov to a shared column: copy cost 2, Φ−1; to an only-held column: in place). OK. Snapshot taken at first chance: free, OK.
- Lemma M + E3 (in-place when M ∈ A = deletion, dominated by the parent): OK. Rule P, Rule G (any σ-image as key is an exact image): OK.
- Dedup is purely state-based (no prefix-syntax rules), so theory's L6.3 pitfall does not arise. Layered BFS with cost-1/2 edges: OK.
- H1 (log2 class size, class = equal flags + index contents + taken-output indices): OK (same argument as L7). H2 (cmov ≥ cmp on a shortest completion, plus und): OK. H3 (DAG cover, L leaves ⇒ ≥ L−1 gates): OK.
- Verdict: **confirmed**. Rules are applied jointly; their soundness arguments do not interfere because only H uses minimality (N2-type) and all other rules are exact state equivalences or dominance.

## R17. sat RULES.md (canon, pcanon, comm, dead, flags, cmpord, movfresh)
- Normal-form argument with measure (non-nop count + pre-cmp cmovs, #misoriented cmps, lex program): each step decreases it; renaming re-applied after deletions/flips; comm swaps keep first-touch order (exception when both touch a fresh register) and keep movfresh's "mov writes a fresh register" (independence: the other step does not touch the mov's dst). A swap can make a mov read an untouched scratch, but that mov is then T-onto-T (fresh dst) = removable, so the process continues; at termination all rules hold. R = n+k suffices for movfresh: #webs ≤ #writes ≤ k−1, plus one never-written register.
- dead in snap counts snapshot slots as reads: OK. cmpord flip changes cmov opcodes in the block: second measure component, OK.
- Verdict: **confirmed (paper level)**. Condition: encoder must use the SAME (op,d,s) order in comm as the register order used by canon/pcanon/cmpord. theory sign-off still required by TEAM rule.

## R18. bounds BOUNDS.md v1 (B1, B2, B3, R1, N1–N4, H)
- B1 (= theory L7): OK. B2 (adjacent pair compared on every s): OK.
- B3 #cmov ≥ Huff(n) = 5/8/12: Lemma D (active paths of different outputs are node-disjoint on a permutation) OK; per output the n shortest active paths to the n leaves are prefix-free (binary unfolding, paths end at leaves) ⇒ Kraft ⇒ Σ d ≥ Huff(n); uniform-average step OK. Verdict: **confirmed**.
- R1 lemma (cmp and mov free, all columns kept): OK. Computed n=3 min m = 6: re-run `python3 agents/bounds/mincmov.py 3 6` → "m<=5: none", m=6 found: **confirmed**.
- H3 Huffman over current columns: merging equal-column registers into one leaf can only lower the Huffman cost, so it stays admissible. OK.
- N1: OK on permutations (first cmp with a fixed outcome makes its block mov/no-op, then the cmp is dead). Verdict: **confirmed**.

## R19. spec: Ullrich & Hack (CGO 2025) model comparison
- Read uh.txt myself (Sec 2.2–2.3, 3.6, 5.1). Confirmed: fixed outputs r1..rn at end, I0 only (explicitly), permutations only, m = 1 for n=3,4,5 (table arithmetic: m=1 matches 10^19.9 / 10^40.0 / 10^71.2; n=6 row 10^108.4 matches m=2). Extra restriction not in spec's list: "Do not read uninitialized registers" (excludes garbage-dest cmov, e.g. my 0-mov sort3 core). Their claim "correct on n! permutations ⇒ correct for all inputs" is not proved for ties (a cmp can give eq on ties where neither cmovl nor cmovg fires); it only matters for their upper bounds.
- Verdict: **confirmed** (+1 restriction). Our RS/I1/unbounded-R/weak-order result is strictly stronger for n=3; for n=4 they have a bound only in their restricted model.

## R20. Lean top-level statements (lean STATEMENTS.md, lean-lrat Check.lean/Results, lean-reflect, coq)
- lean `lower_bound_chain_snap n k iset`: hyp = no RS program of length exactly k, registers < n+k, snapshots ≤ k, opcodes in iset is relaxed-correct; concl = no RS program of length ≤ k (any registers) is XSnap-correct (32-bit, all register files, all flags). States n, k, R = n+k, I (iset param) and the RS output rule. Matches MODEL v1.5 §4.3 (out model). OK.
- Not covered: L5 (M_AD → RS, counting +2n, MM-1); no symmetry rules (H is the plain statement). **Paper must not say "machine-checked for M_AD"**.
- lean-lrat `H_of_checkCert`: Lean-verified no-rules encoder + Lean core verified LRAT checker ⇒ H; done for n=3 I1 k=5,6 (Results), CNFs to k=7. Uses native_decide (axiom Lean.ofReduceBool).
- GAP: lean-lrat re-defines Snap/snapOut/RelaxedSnap in LeanLrat/SnapDefs.lean (same text as lean's Snap.lean; vendor/ copies Machine/X86/OrderType/Reps/Relax/Rename byte-equal, but not Snap). No single build composes H_of_checkCert with lower_bound_chain_snap yet. Sent to lean + lean-lrat.
- lean-reflect: prototype reflection checker (LeanReflect/Basic.lean), tests = permutations only (sound for lower bounds by L1b, must be stated); its SortProof/Machine.lean is an older copy of lean's (only StrictCorrectO missing). coq: tools only. No top-level statement to review yet.
- Verdict: **insufficient** (correct pieces, composition missing; L5 not formal).

## R21. proofs: certificate design (SYMMETRY_CERT.md v1, ENCODING_CERT.md v1, cc_check.py)
- Best chain for n=3 (I agree): lean-lrat verified encoder `enc 3 10 I1 (weakOrderTypes 3)` → F0 (no rules); + canon by VeriPB dominance (literal scratch-swap symmetry, σ(F0)=F0 checked by script and by VeriPB) → F1; cake_lpr: F1 UNSAT. With no instruction-removing rules, lean's `lower_bound_chain_snap` gives "≤ 10" from "exactly 10" (padding, L4a): no sweep needed.
- Remarks: (1) ENCODING_CERT (a) says "AlphaDev x86 claim ⇐ relaxed snapshot model" — overstated: lean proves the RS-register x86 claim; L5 (memory, +2n) is paper only. (2) VeriPB 3.0.2 is unverified (CakePB blocked) — the canon step is then not machine-checked by a verified tool; option A (no rules, cadical → cake_lpr) avoids it for n=3. (3) symcert/k10_I1_snap uses sat's (unverified) encoder for F0; only ll_k10 uses the verified encoder — final n=3 claim must cite ll_k10 or option A on lean-lrat's CNF. (4) cc_check.py logic (summary F + ¬cubes UNSAT, every leaf F + cube UNSAT, glue = multiset clause equality) is sound.
- Verdict: **design confirmed**; results: pending.

## R22. spec/upper: MM+ (memory source operands) beats AlphaDev
- Re-ran own progcheck on memplus_sort2_7 (L=7), upper_sort3_memops_L15, _sort4_memops_L26, _sort5_memops_L40: all correct (strict); operand scan: no cmov to memory, no memory-memory cmp/mov ⇒ legal x86 forms (x86 agent: cmp r,m / cmovcc r,m value semantics = register form on hardware).
- Verdict: **confirmed**. Consequence: T5 is CLOSED with a negative answer for "any x86 operands": the AlphaDev optimality theorem must state MM-1. This is also a strong paper result (shorter real-x86 kernels: 15/26/40).

## R23. proofs: canon + pcanon certified by VeriPB on lean-lrat's rule-free enc (n=3, k=10, I1, snap, 13 types)
- Re-ran generator in my scratch: F0 sha256 identical (1ebfc073…); F1 identical as a clause list (sha differs only by a comment path — remark: hash the clause part, or keep comments path-free). VeriPB: VERIFIED OUTPUT DERIVABLE (mine and theirs). same_clauses: SAME.
- Verdict: **confirmed** (modulo VeriPB, unverified). pcanon over input swaps is valid here because all 13 types are present (type map y → y∘τ), as SYMMETRY_CERT §3 requires.
- Pending: F1 UNSAT by cadical → cake_lpr (run_F1.out started 19:16, tlim 72000 s).

## R24. lean: L5 + MM-1 formalized (mm_lower_bound); lean-lrat: one build, canon in Lean
- `mm_lower_bound n K iset`: H (rule-free RS at K) ⇒ ∀ q, MMProg n q → |q| ≤ K+2n → opcodes ∈ iset → ¬ XCorrect n q. MMProg = mov not cell↔cell, cmp and cmov only on registers ≥ n (MM-1). XCorrect = all 32-bit register files (cells = inputs, scratch = garbage), all flags, cells end sorted. Axioms standard. Verdict: **confirmed** — this is the paper's main statement for M_AD, I as parameter.
- lean-lrat: vendored lean files byte-equal (incl. L5, Snap); SnapDefs gone; canon rule inside the Lean encoder with a Lean soundness proof (Canon.lean) — symmetry breaking no longer needs VeriPB for canon. End theorem exists for K=7 (test); K=10 in progress (cube split, Results/S3_I1c_K10).
- Remaining for the final claim: K=10 instance + the end theorem should call `mm_lower_bound 3 10 (isetOf true)` (lean asked lean-lrat to do so). native_decide (Lean.ofReduceBool) stays in the trust base of the instance.

## R25. sat2: n=3 RS I1 UNSAT k=1..10 (final CEGIS CNFs)
- Re-ran: SHA256SUMS OK; cadical UNSAT k=1..9 (k=9 79 s); k=10: kissat UNSAT 1383 s (cadical > 2400 s). Header of k=10 CNF = sat2's logged final size.
- Verdict: **confirmed** as "these CNFs are UNSAT". Trust: sat2 encoder + RULES (paper-reviewed) + C1 card; not machine-checked. The verified path remains lean-lrat (R24).

## R26. critic: MM+ n=3 optimum = 15 (I1 and I0)
- `bf_mm 3 memplus I1 15 hc`: UNSAT L=0..14 (L=14: 1.2e9 nodes, 2106 s), SAT L=15 (witness = I0 only, judge --strict --model memplus PASS). Validation: n=2 mem 8 / memplus 7. Validation n=3 mem: UNSAT L ≤ 15 so far (expected 17).
- Verdict (self-claim): needs a second tool (enum asked) and theory review of h (BF_NOTES §bf_mm).
