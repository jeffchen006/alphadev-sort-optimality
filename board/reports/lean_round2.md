# lean — round 2 report (2026-10-24)

## Done
1. **L5 formalized** (theory G2), `agents/lean/SortProof/L5.lean`, no sorry, axioms propext / Classical.choice / Quot.sound.
   - `MMProg n q`: registers < n are the memory cells; MM-1 (cells only in load `mov r,i` / store `mov i,r`; cmp, cmov
     and reg-reg mov on registers ≥ n). Same 3 clauses as theory's review. MM semantics = the RF semantics with P = cells.
   - `l5 : 2 ≤ n → MMProg n q → RelaxedCorrect n q → ∃ p o, p.length + 2*n ≤ q.length ∧ (opcodes preserved) ∧ RelaxedSnap n p o`.
   - Proof = theory's translation, with one simplification: register instructions keep the current name; fresh names
     only for the segment registers G i s (s ≥ 1). Invariants I1-I4 (values, segment values, flags, snapshots) and
     N1-N5 (name disjointness). Count: saved_i = #stores_i + [first access of cell i is a load] ≥ 2 by
     (b) every cell is stored (rank lemmas `sortsOK_rank_lt/le`) and (a) the first access is a load (two inputs that
     differ only at x_i give the same final state).
   - `mm_lower_bound n K iset hn hn' H : ∀ q, MMProg n q → q.length ≤ K + 2n → (∀ i ∈ q, i.inSet iset) → ¬ XCorrect n q`,
     H = the rule-free RS search hypothesis at k = K (R = n + K, snapshots free) — the same H as `lower_bound_chain_snap`.
   - `alphadev_mm`: programs/alphadev_sort{3,4,5}.s are MM programs of length 17 / 28 / 42 and XCorrect (upper side in MM).
   - `sort3_optimal_of`: H at K = 10, I1 ⇒ no MM program of length ≤ 16 sorts ⇒ AlphaDev's 17 is optimal.
2. Translation tested by evaluation: k = L − 2n exactly and relaxed-correct on every AlphaDev mem file tested
   (17→11, 28→20, 42→32, 19→13, 20→14, 31→23, 45→33, found/upper_sort5_I0_L42 42→32).
3. **Stable API**: `agents/lean/frozen/v1` and `frozen/v2` (v2 = v1 byte-identical + SortFacts + L5), sha256-checked
   copies used by lean-reflect and lean-lrat (lean-lrat's end theorem already uses `lower_bound_chain_snap`).
4. Peer agreement: theory reviewed STATEMENTS.md v1 (correct); x86 confirmed the flag/cmov clauses vs ACL2 x86isa and the
   CPU (now in SEMANTICS.md); spec §4 reading sent; 3 flag states adopted in MODEL.md v1.2. STATEMENTS.md now lists the
   axioms of every main theorem (critic point 3).

## Numbers
| claim | Lean theorem | status |
|---|---|---|
| AlphaDev sort3/4/5 are MM programs, L = 17/28/42, sort on x86 | `alphadev_mm` | proved (kernel) |
| strict correct, all 39 files n ≤ 5 | `AllPrograms.lean` | proved (kernel) |
| RS search H at K ⇒ no MM program ≤ K + 2n | `mm_lower_bound` | proved |
| H itself (UNSAT at K = 10/19/31) | — | lean-lrat / lean-reflect / sat |

## Open problems
- Theory's review of the `l5` / `mm_lower_bound` text (requested).
- G3 (non-symmetry rules) only if a final claim uses them (asked proofs and sat). The Lean routes need none.
- `out` file ⇔ `XSnap` lemma; checker for n = 6..8. Parser / `program_file%` stay trusted.

## Next
- End-to-end theorem in ONE build with lean-lrat (their H at K = 10 for n = 3, then sort4).
- G3 on request; else help lean-reflect / lean-lrat with the n = 4 run.
