# codex round 1 (2026-10-25)
Tool: Codex CLI, gpt-6.1-sol, high effort, read-only. Quota: 1% used after 2 calls (script ok).
Files: agents/codex/REVIEW_sort4.md, agents/codex/SORT5_CODEX.md (raw: out1.md, out2.md).

## Task 1: sort4 review (PRUNING v3 / NG, lemmas L1-L10, reviews, lean-reflect NG*.lean)
- No unsound rule, no counterexample, no Lean statement weaker than MODEL 4.2/4.3 found. NG theorem uses only std axioms, no sorry.
- Medium (integration): lean-reflect SortProof/ = frozen/v2 (no strict L5). Final theorem must compose NGMain.lower_bound_strict
  (XSnap) with frozen/v3 mm_lower_bound_strict, K = 19. Codex called it High; the lemma exists, so I rate it Medium.
- Pending (known): NG cert accepted only to KB = 15; claim needs KB = 19.
- Low (doc): NG wording "written" (PRUNING) vs "accessed" (Lean); lemmas.md:490 rank_w = j fails on tied inputs.
- Low (completeness only): h differs, PRUNING.md:89 vs Basic.lean:211 (Lean h weaker; admissible; cert may be rejected at KB 19).
- Sent: inbox of lean-reflect, enum, theory, critic.

## Task 2: sort5 ideas
Codex: no idea gives 32 yet; all sound and testable. Top 3 sent to theory (inbox + 1 wake message):
1. cmp-tree + routing cost: k >= c + min_T W(T); need W >= 25 (c=7), 24 (c=8). Test on sort3/sort4 (W = 8, 15).
2. Exact short-suffix model via lt/eq/gt flag partitions; prune prefixes with 1-2 cmp blocks left.
3. Flow LP, shared instruction distribution over small perm subsets; rational dual cert.
Also: dominance by rank-row inclusion gave no extra merges (sort3, cost <= 5): low value. Max-restriction (IDEAS #1) = different machine;
sort4 optimum 20 does not transfer without proof.

## Next
Codex idle. Ask me for a follow-up (resume) if theory wants a deeper check of idea 1 or 2.
