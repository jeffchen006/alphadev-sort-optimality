# How short can a branchless sort be? — AlphaDev sort3 / sort4 / sort5 optimality

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23676958.svg)](https://doi.org/10.5281/zenodo.23676958)

**Paper:** Zhiyang Chen, *How Short Can a Branchless Sort Be? Certified Optimality of AlphaDev's sort3 and sort4 Kernels,
and What Stands in the Way for sort5*, 2026. Zenodo preprint, DOI [10.5281/zenodo.23676958](https://doi.org/10.5281/zenodo.23676958) (PDF also in `agents/theory/paper/main.pdf`).

Code, programs, proofs and results for the paper in `agents/theory/paper/main.pdf` (author: Zhiyang Chen).

**Question.** AlphaDev (Mankowitz et al., Nature 2023) found x86 sorting kernels of 17 / 28 / 42 instructions for 3 / 4 / 5
integers (opcodes `mov`, `cmp`, `cmovl/le/g/ge`; `cmp`/`cmov` on registers only; every instruction counted). Are they shortest?

| n | AlphaDev | result |
|---|---|---|
| 3 | 17 | **optimal** — certified: LRAT proofs checked by `cake_lpr`, a kernel-only Lean 4 theorem, a Rocq proof, and more |
| 4 | 28 | **optimal** — exhaustive search (1.39e9 states, reviewed pruning rules); certificate checked in Lean up to k <= 17 |
| 5 | 42 | **not beaten, not proved** — new 8-comparison family of length 42; no pure min/max kernel of length <= 41; garbage registers never help; open case: kernels that write non-min/max values |

Side results: with memory operands in `cmp`/`cmov` (legal x86, forbidden in AlphaDev's search) the kernels need only
7 / 15 / 26 / 39 instructions for n = 2..5; at optimal length AlphaDev's sort3 and sort5 are not optimal in dependency depth.

## Layout
- `board/FINAL_REPORT.md` — summary of all results; `board/team/FINAL.md` — sort5 search scopes in detail;
  `board/ASSUMPTIONS_42.md` — the evidence for "42 may be optimal" and the assumptions behind each piece.
- `shared/MODEL.md` — the exact model and counting; `shared/judge.py` — reference checker (strict: all weak orders, garbage).
- `programs/` — AlphaDev's kernels, human baselines, and kernels found here (`programs/found/`, `board/team/candidates/`).
- `agents/<role>/` — code per role: `sat`, `sat2` (SAT encodings + CEGIS), `enum` (set-model search), `lean`, `lean-reflect`,
  `lean-lrat` (Lean 4), `coq` (Rocq), `proofs` (cake_lpr / VeriPB / CakePB pipeline), `x86` (hardware and ACL2 x86isa tests),
  `latency`, `upper` (stochastic search), `bounds`, `theory` (proofs, paper), `agents/team/*` (sort5 discovery tools).
- `artifact/` — scripts that re-run each sort3 claim.

## Notes
- Large data (certificates, search states, LRAT proofs; about 230 GB) is not in this repository.
- Absolute paths in scripts were replaced by `/path/to/repo`; adjust them before running.
- The project was carried out with a team of AI coding agents (Claude Code and Codex) under human direction; every claim
  in the paper is backed by a re-runnable check listed in `board/claims.md`.

## Citation
```bibtex
@misc{chen2026branchlesssort,
  author    = {Chen, Zhiyang},
  title     = {How Short Can a Branchless Sort Be? Certified Optimality of {AlphaDev}'s sort3 and sort4 Kernels,
               and What Stands in the Way for sort5},
  year      = {2026},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.23676958},
  url       = {https://doi.org/10.5281/zenodo.23676958}
}
```
