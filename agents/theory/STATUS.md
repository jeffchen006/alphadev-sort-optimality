# theory STATUS (2026-10-24 18:46)
Done (round 1):
- lemmas.md: L1 order type (+ L1b subset/CEGIS), L2 relaxation, L3 R=n+k, L4 padding (sweep / NOP-suffix), L5 MM -> RS
  (L_MM = k_RS + 2n), L6 master lex-min lemma + D-rules R1,R2,R5,R6,R7 + S-rules S1-S5 + implied constraints;
  Appendix A: rule statements in Lean-like form. Reviewed by critic (sound under MM-1).
- check.py: independent strict/relaxed checker (RF/RE/RS, out pseudo-instr). All AlphaDev + upper programs checked.
- Reviews: sat2 RULES.md (sound; notes), sat encode.py (pre-review, sound; justification note), MODEL.md v1.1 §2-3.
- lean_plan.md (G1 RS semantics, G2 L5, G3 rules), veripb_plan.md, paper/outline.md.
Waiting for: agents/sat/RULES.md, agents/enum/PRUNING.md (+ dedup key), bounds BOUNDS.md (#cmp proof), lean statements.
- paper/appendix_proofs.tex: L1-L7 + main theorem in LaTeX, L5 with simulation invariant. l5map.py: L5 translation, tested.
- Task 2 (claims re-run) moved to critic (coordinator 2026-10-24). VeriPB: proposed to proofs that proofs owns SYMMETRY_CERT.md.
Next: review sat RULES.md, enum PRUNING.md, BOUNDS.md, lean statements; Q-G if time.
- [2026-10-24 19:05] Rule reviews done (agents/theory/reviews/): enum PRUNING v1 SOUND; sat RULES v1 SOUND (3 text fixes: L3-normal start,
  rename at start, slot-distinctness implied); sat2 R5/R6 SOUND (deadw boundary check); bounds B2/B3/D/R1/N1-N4/H CORRECT.
  proofs owns SYMMETRY_CERT.md; I sent the soundness statement and witness notes. Re-ran enum n=3: none<=10 (I1, weak orders
  and perms only).
- [2026-10-24 19:15] Round 2: reviews (critic BF, lean STATEMENTS, sat v2 items), L8 (MM+, k_out vs k_end), L9 (split checklist),
  paper/main.tex draft 1 (compiles). Waiting: SORT5_SPLIT.md, sat RULES v3, n=3 RS/I1 cake_lpr, n=4 claims, lean G2.
- [2026-10-24 19:31] Round 3: SORT5_SPLIT v0, sat v3+hcmp, MM+ abstraction reviewed (sound); paper merged with spec sections (14 pp). Waiting: n=3 k=10 cake_lpr, lean G2, n=4 claims.
- [2026-10-24 19:40] enum PRUNING v2: H3' sound, Lemma NG consequence has a GAP (read-but-unwritten T dst); fix A proposed. bounds R2/R4 sound. sat2 n=3 claim reviewed. Paper results row n=3: 4 independent tools.
- [2026-10-24 19:48] enum PRUNING v3 NG reviewed: sound (+ all-T cmov mapping fix).
- [2026-10-24 20:55] Round 4: latency B/C, CERT_OBLIGATIONS.md, enum n=4 <=18 reviewed, paper latency subsection. Waiting: enum k=19, l5_strict, sort3_mm_optimal.
- [2026-10-24 23:24] Round 5: sort3 headline theorem in paper (10-route trust table); H3' lemma for coq; I2 lemma L11; reviews of lean-reflect, coq, CakePB, sat/sat2 certs, x86 ACL2.
