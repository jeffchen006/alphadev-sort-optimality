# lean-reflect — round 2 report (2026-10-25)

## Done
1. **AlphaDev-model theorem** `LeanReflect.sort3_mm_lb : ∀ q, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q`
   (= `sort3_rs_lb` + lean's L5 `mm_lower_bound`, frozen/v2). theory: statement = MODEL §4.2. Trust: kernel + compiler.
2. **New proved rules** (core Lean, no `sorry`):
   - set model = enum's Lemma S (`SetSound`: key ⊇ register columns, potential Φ, costs 1/1/2/1);
   - rule G = S_n input relabelling (`SymSound`; the proof works for any re-indexing of the tests);
   - rule H3' = cover bound (`Cover.lean`: the cover number by registers drops by ≤ 1 per cmov and not on a cmov that
     creates another output; outputs are created only by cmovs). `h = H1 + max(#undone, #undone + max cover − 2)`.
   Fast array paths, each with a proved equality to the list form.
3. **Certificates**: format v1 agreed with coq (`agents/lean-reflect/CERT_FORMAT.md`); Lean reader/writer + `certexe`;
   theorems that read the certificate from a file (`FileCert.lean`: opaque + implemented_by; the soundness theorem holds
   for every list). Negative tests: missing file and a file without the g=7 layer → check false.
4. **sort3 certificates** (all `checkG = true`):

   | rules | states | theorem | time |
   |---|---|---|---|
   | multiset (round 1) | 437,100 | `sort3_rs_lb` / `sort3_x86_lb` | 858 s, 4 cores |
   | set + G | 56,816 | `sort3_rs_lb_G` | ~3 min |
   | set + G + H3' | 2,215 | `sort3_rs_lb_H` (file) / `sort3_rs_lb_H'` | 83 s build |
   | enum's file, same rules | 2,219 | `certexe check` | 14 s |
5. **Cross-check with enum**: my Lean search and enum_out with the same rules give identical counts (n=4 KB=12/13/14:
   17 / 247 / 5,896). Exporter `proto/enum_cert.cpp` (copy of coq's patched enum_out + `EXPORT=FILE`).
6. **sort4 k ≤ 15** (not the AlphaDev bound): enum-code certificate, 160,021 states — `checkGPar = true`, 4,006 s on 4 cores, 0.96 GB; theorem `LeanReflect.sort4_rs_lb15 : ∀ p o, p.length ≤ 15 → ¬ RelaxedSnap 4 p o` built (4,223 s, 1.3 GB).
7. All theorems rebuilt on the final `h` (H3'); axioms = propext, Classical.choice, Quot.sound + one native_decide axiom each (positive side: none); no `sorry`; core copy sha OK.
8. For lean's kernel route: `checkG` is stable; sort3 certificate is now 2,215 states (was 437K): ~1–2 CPU-h in the kernel
   at lean's measured 2 s/state.

## Open problems
- enum's sort4 k ≤ 19 result (1.39e9 states) uses **NG** (strict model) and **H2**; my checker proves neither. NG needs
  the strict semantics (program rewriting, Lemma NG v3) and lean's `l5_strict`.
- **Speed**: ~10 states/s per core for n=4 (list columns, allocation ~35%). k ≤ 18 (55.8M) ≈ 2 core-months; k ≤ 19
  ≈ 4 core-years. Needs packed columns (n=4: 24 base-5 digits fit in one machine word) and ~100–1000×.
- My relaxed rule set grows ~27× per KB at n=4 (KB=16: 5.0M states) — k=19 by relaxed rules alone is ~1e11 states.

## Next
1. Packed-column checker (Nat-coded columns, proved equal to the list checker); target ≥ 1000 states/s at n=4.
2. Formalize H2 and NG (strict route; with lean's `l5_strict`), then check enum's k ≤ 17 file (2.56M states), then 18.
3. Kernel-only sort3: support lean with the 2,215-state certificate.

## Re-run
cd agents/lean-reflect && ./check_core.sh && lake build LeanReflect.Sort3MM LeanReflect.Sort3H LeanReflect.Positive
.lake/build/bin/certexe check 4 15 I1 certs/enum_sort4_I1_k15.cert 4
