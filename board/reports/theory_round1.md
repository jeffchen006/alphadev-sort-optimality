# theory — round 1 report (2026-10-24)

## Done
- `agents/theory/lemmas.md` (LaTeX-ready). Paper proofs of every link of the trust chain:
  - L1 order type (Fubini 13/75/541, computed) + L1b: any subset of order types (permutations, CEGIS set) is sound for lower bounds.
  - L2 relaxation (T = INT_MAX, inputs < INT_MAX, cmp(T,T) = eq, initial flag eq = real state ZF=1, SF=OF). Garbage reads:
    sound for any program. Completeness risk: T is a known +inf sentinel, so relaxed k_min can be smaller; stronger sound
    remedy given (scratch +inf AND -inf, all 3 flags).
  - L3 R = n + k (needs >= 1 cmp; read-only scratch merge into one T register).
  - L4 padding: with no rules, UNSAT at k covers all k' <= k (`mov P0,P0`). With rules, NOT monotone: sweep every k, or NOP-suffix.
  - L5 counting map: memory program (memory only via mov = MM-1; any interleaving, reloads, spills) of length L
    => snapshot program (RS = spec's M_out) of length <= L - 2n; converse k => k + 2n. So L_AD = k_RS + 2n. spec found the
    same lemma; I fixed one step (fresh register per store-segment, not per cell).
  - L6 master lemma: lex-least program in the closure under scratch renaming, input renaming (RS only), independent swaps
    (snapshots move with the swap), cmp flip, pre-cmp cmovle/ge -> mov. Gives D-rules R1, R2, R5, R6, R7 jointly; S-rules S1-S5
    (no-op, dead write, dead cmp, cmov before first cmp, cmp A,A) by minimality; implied constraints (sat2 `live`) combine freely.
    Pitfalls: one instruction order for all lex rules; cmov reads its destination; dedup + syntactic rules (enum) can be unsound.
  - L7 #cmp >= ceil(log2 n!) = 3/5/7 (critic's proof, checked).
  - Appendix A: all rules in Lean-like syntax (for lean, lean-reflect, coq).
- KEY FINDING: MODEL v0 output rule (P_j at end, "RF") is too strict; an RF bound is not an AlphaDev bound. Now fixed in
  MODEL.md (spec §4 M_out, my §2-3 v1.1). Evidence: all AlphaDev register cores are correct in RE/RS, none in RF.
- `agents/theory/check.py`: independent strict/relaxed checker (RF/RE/RS, `out` lines).
- Critic pass on `board/claims.md`: re-ran and CONFIRMED critic (lengths 17/28/43, le->l breaks sort3/sort5), spec (judge
  PASS on all programs; Lemma 4.1 with segment fix), upper (sort5 in I0 at L = 42, MM-1 respected), bounds (7-cmp sort5).
  Agreed REFUTED: "permutations + I0 relaxes weak orders + I1" (use permutations + I1). No lower-bound claim exists yet.
- Rule reviews: sat2 RULES.md = sound (plus: comm in snap mode, R6 compatibility proof, `live` sound). sat encode.py pre-review =
  sound; its RULES.md must justify "no cmov before first cmp" for cmovle/ge by replace-with-mov. critic reviewed lemmas.md: sound
  under MM-1; all remarks applied.
- `agents/theory/lean_plan.md`: lean has L1-L4 for RF. Priority: G1 snapshot semantics + chain for RS; G2 L5 (most novel link);
  G3 master lemma + only the rules a final claim uses.
- `agents/theory/veripb_plan.md`: VeriPB (dominance, v2/v3 kernel, satsuma/BreakID, CakePB) certifies static lex-leader for
  literal permutations only. Fits R1/R6 with one-hot selectors only; poor fit for swaps, flips, minimality rules. Plan: rules
  trusted by paper + Lean + rules-on/off agreement; best certificate = rule-free runs for sort3 (and sort4 if affordable);
  optional VeriPB pilot for R1 on sort3.
- `agents/theory/paper/outline.md`: problem, model, trust-chain table, results, threats to validity, related work.

## Numbers
- Targets (RS, I1, MM-1): UNSAT for every k <= 10 / 19 / 31 (n = 3/4/5) => AlphaDev 17/28/42 optimal.
- #cmp >= 3 / 5 / 7.

## Open problems
- agents/sat/RULES.md and agents/enum/PRUNING.md (+ enum dedup key) not written yet: no rule-based final claim before review.
- RE = RS (min length) not proved; final claims must use snapshot outputs.
- MM-1 is a model choice (x86 has `cmp r,m`, `cmovcc r,m`): variant MM+ open (suggest `upper` tries n = 3).
- Q-G: is the strict optimum reached without garbage reads? Not needed for soundness.
- Lean statements for G1-G3 not yet reviewed (none sent yet).

## Next
Review sat/enum rule files and the first lower-bound claims (check n, k, R, I, C, model, rules, test set, sweep).
Review Lean top-level statements. Write L5 and L6 as full appendix text for the paper.

## Addendum (after coordinator update, 2026-10-24 18:52)
- Brief change accepted: critic now re-runs claims; I focus on proofs, rule review, paper. Quota 2 cores.
- `paper/appendix_proofs.tex`: L1–L7, master lemma, joint soundness, main theorem in LaTeX; L5 with a simulation invariant.
- `l5map.py`: independent implementation of the L5 translation. On all 23 memory programs with n ≤ 5 (AlphaDev, human, upper):
  k ≤ L−2n, and every result is relaxed+strict correct (claims.md). SI Sort3_19 → 13 (spec's ad2out gives 14).
- bounds B1 (#cmp ≥ ⌈log2 n!⌉) reviewed: correct (= L7).
- VeriPB: proposed to `proofs` that it owns SYMMETRY_CERT.md; I give witness design and soundness statements. Waiting for reply.
- Asked sat and enum again for RULES.md / PRUNING.md (not written yet). Sent lean the exact statements.

## Addendum 2 (2026-10-24 19:05) — rule reviews
- enum PRUNING.md v1: SOUND. Lemma S (set model = M_out, potential argument checked case by case), Lemma M, rules W/E/P/G/D,
  heuristics H1–H3 admissible. State-based pruning only, so exact dedup is safe. Re-run: n=3, I1: none ≤ 10 (weak orders, and
  permutations only).
- sat RULES.md v1: SOUND (canon, pcanon, comm, dead, flags, cmpord, movfresh). The rewriting argument needs no minimality.
  Text fixes: start from an L3-normal program (else movfresh may need > k scratch); rename at the start; slot distinctness is
  implied by full correctness.
- sat2 R5 (snapshot moved later) and R6 (lex-leader over P permutations): SOUND; check the deadw boundary convention.
- bounds B2 (adjacent pair), B3 (#cmov ≥ Huff(n) = 5/8/12), Lemma D, Lemma R1, N1–N4, heuristic H: CORRECT. Caution: N1 is a
  transformation rule; do not mix with other teams' D-rules without a joint proof.
- Rule sets of sat / sat2 / enum use different orders: never mix them in one encoding.
- proofs owns SYMMETRY_CERT.md; soundness statement: VeriPB certifies "F0 SAT ⇒ F0 ∧ SB SAT", LRAT certifies F0 ∧ SB UNSAT.
