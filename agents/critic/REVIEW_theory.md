# critic review of agents/theory/lemmas.md v1 (2026-10-24)

Verdict: the chain (L2 → L5 → L3 → L6.0 → L1/L1b) is sound as written, for MM under MM-1. Remarks, most important first.

1. **MM-1 is a model choice, not a fact.** AlphaDev Methods: "We cannot compare or conditionally move to a memory location";
   the intro example says "illegal ... comparing two memory locations". Real x86 has `cmp r, m` and `cmovcc r, m` (memory
   SOURCE). The text does not clearly forbid them. The theorem must say "memory only via mov" in its statement, and the paper
   must give this as a model restriction (same as AlphaDev's listings, which never use it). Variant MM+ (memory sources allowed)
   is a natural referee request: L5 then fails (a load merges into a cmp/cmov). Suggest `upper` tries MM+ for n=3.
2. **L5 converse / equality.** The forward direction is proved in T-relaxed semantics; the converse (RS k → MM k+2n) is only
   needed for "AlphaDev's L gives k = L − 2n". State which semantics the equality $L^{\min}_{MM} = k^{\min}_{RS} + 2n$ is in
   (the converse keeps strict correctness, the forward map keeps relaxed correctness; so the equality is for relaxed minima,
   and only "≥" is needed for the main theorem).
3. **L5 detail checked:** per-segment fresh registers fix the reload problem; ranges of the same register are disjoint (a load
   or mov ends a range); non-last loads come before the renamed range, so they read the pure segment value; snapshot uses the
   current name. Count: −1 per slot for segment 0, −1 for the last segment; segment 0 ≠ last segment by (1)+(2). OK.
4. **L6.0 joint soundness:** correct because every D-rule is "g(p*) ⊀ p*" for ONE order ≺. Two encoders (sat, sat2) use
   DIFFERENT orders (sat2: code = (op, dst, src) with mov=0, cmp=1, cmovl=2, ...; R1 by FIRST WRITE plus `tread`). That is
   fine only if each encoder's rule set is proved against its own order (sat2 does this in its RULES.md). Rules must never
   be mixed across encoders.
5. **L6.2 S2 in RS:** a write read only by a snapshot is not dead. sat2 asserts `deadw` is off in snap mode — good. Check
   that `sat` and `enum` do the same.
6. **L6.3 (dedup + syntactic rules):** important; my own search keys the state on the one syntactic bit it uses
   ("last instruction was cmp"). Ask `enum` to state its key.
7. **L3(a)** uses "no cmp ⇒ every label constant". In I1 a pre-cmp cmovle acts as mov: still constant. OK.
8. **L2 remark 4 (relaxed may be shorter than strict):** for n=2 my search finds k=4 using `cmovg new, x0` into a T register
   (no mov). It is strict-correct on x86 (the garbage is read only under the same flag) but ILLEGAL in AlphaDev's game
   ("cannot use non-initialized registers"). So relaxed RS ⊋ AlphaDev's action space; fine for soundness, but a relaxed
   SAT at L−2n−1 would not refute AlphaDev optimality in AlphaDev's game — it would only be a new real-x86 program.
9. Small: L1 should say "T compared with T is eq" in the abstract semantics (it is in L2 checks; put it in L1 too).
