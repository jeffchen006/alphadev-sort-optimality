# Review of agents/enum/PRUNING.md v3, Lemma NG (rewrites a-e + garbage counter γ) — theory, 2026-10-24

**Verdict: SOUND, with one fix in the Lemma-S mapping (below).** v3 closes the gap of v2 (read-but-unwritten destination).

Rewrites (strict model; S pristine = never written; rewrite at S's FIRST access; process in time order, so an earlier
first access is already rewritten and every other operand is either non-pristine or also at its first access):
- (a) cmovX S,E -> mov S,E, g_S := E_t: S = E_t either way; E unchanged. OK.
- (b) cmovX E,S -> mov S,E, g_S := E_t: E unchanged either way; S = E_t. OK.
- (c) mov D,S -> mov S,D, g_S := D_t: D unchanged; S = D_t. OK.
- (d) cmp X,S -> mov S,X + eq-rewrite of the block (cmovl/g deleted, cmovle/ge -> mov), g_S := X_t: original flag = eq;
  flags differ afterwards only where no instruction reads them. OK.
- (e) cmp S,S -> deleted + eq-rewrite. OK.
- Double-pristine: cmp A,B and cmovX A,B -> mov A,B with g_B := g_A. Correct, and better than deleting: it keeps A and B
  equal for later reads (deleting would decorrelate them). OK.
- Garbage choice may depend on x, the other garbage and the initial flags, because S is not accessed before t. The
  rewritten program never reads g_S, so it is correct for all g_S. Length does not grow. Termination: each rewrite removes a
  first-access read of a pristine register and adds none. OK.
After the rewrites: the only pristine reads are garbage movs mov A,B (A, B pristine at their first access).

Set model with γ:
- garbage mov (cost 1, γ += 2), T as source / cmp operand needs γ >= 1, T-cmov (cost 1, needs γ >= 1, γ -= 1), copy cost 2;
  cap γ at 7 = a relaxation (more allowed). Monotone in γ (more γ never hurts). Rules P, G, D, H1-H3' unaffected. OK.
- FIX (mapping in "Lemma S with NG"): "all other cases unchanged" leaves one case uncovered: a CMOV whose result is all-T
  (e.g. cmov D,G that fires on every type, or cmov G1,G2) makes D a register that holds T without being a "garbage
  register" by your definition; a later cmov into D is then a T-cmov in the set model that needs γ >= 1, but γ was not
  increased. Repair: define "garbage register" = any written register that holds all-T, and map EVERY instruction that
  leaves an all-T value in a register (garbage mov, mov C,G, a cmov with all-T result) to the set op "garbage mov"
  (cost 1 = its register cost; in v1 such a cmov cost 0, so the set cost still stays <= |P*|). Then the invariant
  γ >= #garbage registers holding T holds in every case. No code change is needed if the generator already allows a garbage
  mov at any time (it is unconditional); only the proof text changes.
Chain: MM strict -> (L5, strict) RS strict -> NG rewrites (strict) -> L2 relaxed -> set model with γ. Claims with NG=1 are
about strict-correct programs (the AlphaDev claim). Fine.
