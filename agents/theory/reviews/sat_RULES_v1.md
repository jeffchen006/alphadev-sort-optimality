# Review of agents/sat/RULES.md (v1) — theory, 2026-10-24

**Verdict: SOUND** (canon, pcanon, comm, dead, flags, cmpord, movfresh), with 3 text fixes. The normal-form (rewriting)
argument is a valid alternative to my lex-min lemma (L6.0) and is even stronger: it needs no minimality, because every
removal appends a nop (length <= k is kept). So "no rule-satisfying program of length <= k (nop mode)" => "no correct
program of length <= k".

Checked:
- Measure (c1 = #non-nop + #cmov before the first cmp, c2 = #misoriented cmps, c3 = lex rank) is well founded; each step
  decreases it: removal/replacement/cmp r,r (c1; cmp r,r: its readers are exactly the cmovs up to the next cmp, all replaced
  or deleted, so none becomes "before the first cmp"); cmpord flip (c2; c1 unchanged; flip changes no first-touch order
  when <= 1 operand is fresh, and with 2 fresh operands canon already orients it); comm swap (c3; c1, c2 unchanged; canon,
  pcanon, movfresh stay true when at most one of the two steps has a first touch).
- canon / pcanon: renaming by first touch, dst before src = exactly the encoded condition. pcanon only snap/free: right.
- comm: independence = Bernstein with the flag as a location; snap slots move with their step (value unchanged).
- dead: liveness with cmov/cmp reading their dst, free/fixed end outputs, and snap slot = the step's own slot. Correct,
  because the only snapshot of a value written at step i is slot i (canonical slots).
- flags: replacement of pre-cmp cmovle/cmovge by mov (c1 decreases). Correct.
- movfresh: web = live range from a mov to the next mov of that register (cmovs continue it). Renaming a web to an
  untouched scratch is semantics-preserving; free/snap only. `mov S_new, S_untouched` = T onto T = no-op.

Text fixes (no code change needed):
1. **Start the process from an L3-normal program** (read-only scratch registers merged into one T register). Otherwise
   the claim "a fresh scratch always exists with R = n + k" can fail: many distinct read-only T registers plus one register
   per web can exceed k scratch. With the merge: #webs <= #writing steps <= k-1 (>= 1 cmp), plus 1 T register <= k.
2. Apply the renamings (canon, pcanon, movfresh) once at the start too, not only after steps 1/2.
3. "Two outputs never share a slot" is an implied constraint of FULL correctness (distinct targets differ on a strict
   order), so it holds for any CEGIS test set; no need for "CEGIS starts with the identity type".
Joint use: these rules must not be mixed with sat2's or enum's rules (different orders and naming conventions).
