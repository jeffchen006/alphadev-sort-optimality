# spec — round 2 report (2026-10-24)

## Done
1. **§4 readings**
   - 8 agents replied, and their readings match §4: sat, sat2, theory, critic, bounds, x86, lean, latency.
   - enum and upper did not reply, although I pinged them twice. Their own documents match §4 (enum PRUNING.md Lemma S = M_out; upper STATUS.md uses the same models). Log: `agents/spec/readings.md`.
   - No reading differs, so §4 needed no fix.
2. **MM+ variant (x86 memory SOURCE operands)**: MODEL.md v1.6 §4.5 and `shared/judge.py --model memplus`.
   - Allowed: `cmp S,P`, `cmp P,S`, `cmovX S,P`. Forbidden: 2 P operands, P as cmov destination, `mov P,P`.
   - Every instruction counts 1.
   - What fails: Lemma 4.1 (>=), for three reasons (theory L8):
     - a load cannot be renamed away when a later cmp/cmov reads the cell;
     - a final store cannot be deleted when the cell is read again;
     - x_i can reach a register by a cmov from memory alone.
   - Only L_MM+ >= k_out holds in general.
   - Evidence that MM+ is strictly stronger:
     - n=2: L=7 (`programs/variants/memplus_sort2_7.s`) < L_AD(2) = 8;
     - upper's MM+ kernels: n=3 L=15 < 17, n=4 L=26 < 28, n=5 L=40 < 42. All PASS judge `--strict --model memplus`.
   - So the AlphaDev claim depends on MM-1, which is AlphaDev's own rule. Sent to theory, upper, x86.
3. **"k_out = k_end?" settled for the claims** (with theory, L8). This is MODEL.md v1.6 §4.3.
   - All AlphaDev cores sort with stores moved to the end, so k_end <= L_AD - 2n.
   - So a proof of k_out >= L_AD - 2n gives k_out = k_end.
   - n=2: k_out = k_end = 4, by my own exhaustive search without pruning (`agents/spec/tools/tiny_search.py 2 4`, 4 min). So L_AD(2) = 8.
   - n=3: 11 (enum + critic).
   - We do not need a lemma for all n.
4. **Paper text**: `agents/spec/paper/` (LaTeX; `spec_sections.tex` compiles to 7 pages with no errors). Theory has the file list.
   - `background.tex`: AlphaDev background, Table 1a, an instruction-mix table, the reconstructed human networks (2n+4c), quotes of the brute-force claim and the pruning rules.
   - `model_counting.tex`: the counting (with quotes), I0/I1, flags, MM, MM-1, RS and the snapshot lemma, RE vs RS, MM+.
   - `related.tex`: Ullrich & Hack, with a 9-row point-by-point table; also Neri, Tunney, Mimicry, superoptimizers, sorting networks.
   - `spec_bib.tex`: the bibliography entries.
5. **Prior work**: no UNVERIFIED items left (`agents/spec/prior_work.md`).
   - Tunney blog: read via web.archive.org. Her 17-instruction x86 sort3 is now `programs/variants/tunney_sort3_17.s` and passes the strict judge (it needs I1). Her 14-instruction version is ARM64 `csel`, outside the model.
   - Mimicry: read via web.archive.org. It uses shuffle indices and SIMD, so it is outside the model.
   - Hacker News claims: dropped (no primary source found).

## Numbers
- RS / MM targets: UNSAT for every k <= 10 / 19 / 31 (n = 3/4/5), I1, which is L_AD >= 17 / 28 / 42.
- n=2: k = 4, L = 8 (exhaustive). n=3: k = 11 (enum + critic; the certificate is with `proofs`).
- MM+ upper bounds: L = 7 / 15 / 26 / 40 for n = 2..5.

## Open problems
- enum and upper: no explicit reading yet. Their documents match §4.
- Hardware runs are still needed for MM+ sort2 and sort3. I asked `x86`.
- Optimal lengths in MM+ are open. They need their own encoding (cells readable by cmp/cmov, outputs fixed to cells). This is a side result, not the main claim.
- The paper text must still be merged into theory's main.tex. Theory owns the structure.

## Next
- Check the model statement (n, k, R, I, C, output rule, k-sweep) of each final lower-bound claim against §4.
- Run the judge on every new program in `programs/found/`.
- Update the paper text when the results come in (remove the \pending markers).
