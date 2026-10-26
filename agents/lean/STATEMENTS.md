# Key Lean statements (verbatim, extracted by tools/statements.py; for review by `theory`)

Build: `cd agents/lean && lake build`. Axioms: propext, Classical.choice, Quot.sound only.

### `SortsOK` (SortProof/Machine.lean)
```lean
/-- Sorting specification: output registers `P0..P{n-1}` hold the inputs in ascending order,
  i.e. they equal `List.mergeSort` of the input list (core Lean's verified sort). -/
def SortsOK (n : Nat) (x y : Nat → Int) : Prop
```

### `StrictCorrect` (SortProof/Machine.lean)
```lean
/-- Strict model: correct for every initial state (every input, every garbage value
  of the scratch registers, every flag state). Values are unbounded `Int`;
  `X86.lean` transfers this to 32-bit registers. -/
def StrictCorrect (n : Nat) (p : Program) : Prop
```

### `StrictCorrectO` (SortProof/Machine.lean)
```lean
/-- Strict model with outputs read from registers `o j` (used for MODEL.md §4.3 `model=out`:
  `out j, S` is `mov O_j, S` into a fresh register `O_j` that nothing reads). -/
def StrictCorrectO (n : Nat) (o : Nat → Nat) (p : Program) : Prop
```

### `relaxInit` (SortProof/Machine.lean)
```lean
/-- Initial state of the relaxed model: `P i = x i`, every scratch register = `T`, flags = eq. -/
def relaxInit (n : Nat) (x : Nat → Int) (T : Int) : State Int
```

### `RelaxedCorrect` (SortProof/Machine.lean)
```lean
/-- Relaxed model (MODEL.md section 2): correct whenever all inputs are `< T`,
  all scratch registers start as `T`, and the flags start as eq. -/
def RelaxedCorrect (n : Nat) (p : Program) : Prop
```

### `XCorrect` (SortProof/X86.lean)
```lean
/-- x86 correctness: for every 32-bit register file and every flag state, the outputs
  `P0..P{n-1}` hold the inputs sorted ascending as signed 32-bit numbers. -/
def XCorrect (n : Nat) (p : Program) : Prop
```

### `XCorrectO` (SortProof/X86.lean)
```lean
def XCorrectO (n : Nat) (o : Nat → Nat) (p : Program) : Prop
```

### `xRelaxInit` (SortProof/Relax.lean)
```lean
/-- The 32-bit relaxed initial state: `P i = xin i`, scratch = INT_MAX, flags = eq. -/
def xRelaxInit (n : Nat) (xin : Nat → BitVec 32) : XState
```

### `Snap` (SortProof/Snap.lean)
```lean
abbrev Snap
```

### `snapOut` (SortProof/Snap.lean)
```lean
def snapOut (p : Program) (o : Snap) (s : State Int) : Nat → Int
```

### `RelaxedSnap` (SortProof/Snap.lean)
```lean
def RelaxedSnap (n : Nat) (p : Program) (o : Snap) : Prop
```

### `xsnapOut` (SortProof/Snap.lean)
```lean
def xsnapOut (p : Program) (o : Snap) (s : XState) : Nat → Int
```

### `XSnap` (SortProof/Snap.lean)
```lean
/-- RS correctness on x86: all 32-bit register files and all flag states. -/
def XSnap (n : Nat) (p : Program) (o : Snap) : Prop
```

### `Cond.xeval` (SortProof/X86.lean)
```lean
/-- CMOVcc condition (SDM Vol. 2A "CMOVcc", Table B-1 condition codes). -/
def Cond.xeval (s : XState) : Cond → Bool
  | .l => s.sf != s.of                       -- CMOVL / CMOVNGE : SF ≠ OF
  | .g => !s.zf && (s.sf == s.of)            -- CMOVG / CMOVNLE : ZF = 0 and SF = OF
  | .le => s.zf || (s.sf != s.of)            -- CMOVLE / CMOVNG : ZF = 1 or SF ≠ OF
  | .ge => s.sf == s.of                      -- CMOVGE / CMOVNL : SF = OF
```

### `xcmp` (SortProof/X86.lean)
```lean
/-- CMP a, b: compute a - b, set CF ZF SF OF, discard the result (SDM Vol. 2A "CMP", "SUB"). -/
def xcmp (s : XState) (a b : BitVec 32) : XState
```

### `XState.flagOrd` (SortProof/X86.lean)
```lean
/-- Abstraction: values = signed value `toInt`; flag state = the order that the conditions see. -/
def XState.flagOrd (s : XState) : Ordering
```

### `xeval_eq` (SortProof/X86.lean)
```lean
/-- Every x86 flag combination maps to one `Ordering`, and all four conditions are functions
  of it. (This fails for cmove/cmovne; those are outside I1.) -/
theorem xeval_eq (s : XState) (c : Cond) : c.xeval s = c.eval s.flagOrd
```

### `cmp_sf_of` (SortProof/X86.lean)
```lean
/-- After `cmp a, b`: SF ≠ OF ⇔ a < b (signed). Kernel proof via `toInt` arithmetic
  (an earlier `bv_decide` proof added a native-code axiom). -/
theorem cmp_sf_of (a b : BitVec 32) :
    ((a - b).msb != ((a.msb != b.msb) && ((a - b).msb != a.msb))) = a.slt b
```

### `cmp_zf` (SortProof/X86.lean)
```lean
/-- After `cmp a, b`: ZF ⇔ a = b. -/
theorem cmp_zf (a b : BitVec 32) : ((a - b) == 0#32) = (a == b)
```

### `xcmp_flagOrd` (SortProof/X86.lean)
```lean
theorem xcmp_flagOrd (s : XState) (a b : BitVec 32) :
    (xcmp s a b).flagOrd = compare a.toInt b.toInt
```

### `xrun_abs` (SortProof/X86.lean)
```lean
/-- Simulation: running on x86 then abstracting = abstracting then running abstractly. -/
theorem xrun_abs (p : Program) (s : XState) : (xrun p s).abs = run compare p s.abs
```

### `strict_to_x86` (SortProof/X86.lean)
```lean
theorem strict_to_x86 {n : Nat} {p : Program} (h : StrictCorrect n p) : XCorrect n p
```

### `run_strictMono` (SortProof/OrderType.lean)
```lean
/-- Order-type lemma, monotone form: execution commutes with every strictly monotone map. -/
theorem run_strictMono (f : Int → Int) (hf : ∀ a b, a < b → f a < f b) (p : Program)
    (s : State Int) : run compare p (s.map f) = (run compare p s).map f
```

### `index_pattern` (SortProof/OrderType.lean)
```lean
/-- Order-type lemma, index-pattern form. -/
theorem index_pattern {R : Nat} {p : Program} (hp : Program.WF R p) (u v : State Int)
    (hflag : u.flag = v.flag)
    (hord : ∀ i j, i < R → j < R → compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    ∃ σ : Nat → Nat, (∀ r < R, σ r < R) ∧
      (run compare p u).regs = (fun r => u.regs (σ r)) ∧
      (run compare p v).regs = (fun r => v.regs (σ r)) ∧
      (run compare p u).flag = (run compare p v).flag
```

### `correct_transfer` (SortProof/OrderType.lean)
```lean
/-- Correctness on `u` iff correctness on `v`, if `u`, `v` have the same weak order type on
  the registers `< R` and the same flag state. -/
theorem correct_transfer {n R : Nat} {p : Program} (hp : Program.WF R p) (hn : n ≤ R) (u v : State Int)
    (hflag : u.flag = v.flag)
    (hord : ∀ i j, i < R → j < R → compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    SortsOK n u.regs (run compare p u).regs ↔ SortsOK n v.regs (run compare p v).regs
```

### `correct_transfer_all` (SortProof/OrderType.lean)
```lean
theorem correct_transfer_all {n : Nat} (p : Program) (u v : State Int) (hflag : u.flag = v.flag)
    (hord : ∀ i j, compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    SortsOK n u.regs (run compare p u).regs ↔ SortsOK n v.regs (run compare p v).regs
```

### `strict_iff_reps` (SortProof/Reps.lean)
```lean
/-- Correct for all `Int` states iff correct on every representative (and every flag state). -/
theorem strict_iff_reps {n R : Nat} {p : Program} (hp : Program.WF R p) (hn : n ≤ R) :
    StrictCorrect n p ↔
      ∀ c ∈ reps R, ∀ fl : Ordering,
        SortsOK n (vecRegs c) (run compare p ⟨vecRegs c, fl⟩).regs
```

### `x86_iff_reps` (SortProof/Reps.lean)
```lean
/-- Order-type corollary over Int32: correct for every 32-bit register file and every flag
  state iff correct on each representative of each weak order type of the `R` registers. -/
theorem x86_iff_reps {n R : Nat} {p : Program} (hp : Program.WF R p) (hn : n ≤ R)
    (hR : R ≤ 2 ^ 31) :
    XCorrect n p ↔
      ∀ c ∈ reps R, ∀ fl : Ordering,
        SortsOK n (vecRegs c) (run compare p ⟨vecRegs c, fl⟩).regs
```

### `strict_to_relaxed` (SortProof/Relax.lean)
```lean
theorem strict_to_relaxed {n : Nat} {p : Program} (h : StrictCorrect n p) : RelaxedCorrect n p
```

### `x86_to_relaxed` (SortProof/Relax.lean)
```lean
/-- Relaxation lemma, x86 form. A program that is correct for all 32-bit garbage values and
  flag states is correct in the relaxed model (for every `Int` input and every `T` above the
  inputs). The proof only uses the x86 runs from `xRelaxInit` with inputs `< INT_MAX`. -/
theorem x86_to_relaxed {n : Nat} {p : Program} (hn : n < 2 ^ 31 - 1)
    (h : ∀ xin : Nat → BitVec 32, (∀ i < n, (xin i).toInt < 2 ^ 31 - 1) →
      SortsOK n (fun r => (xin r).toInt) (fun r => ((xrun p (xRelaxInit n xin)).regs r).toInt)) :
    RelaxedCorrect n p
```

### `xcorrect_to_relaxed` (SortProof/Relax.lean)
```lean
/-- Instance of the hypothesis of `x86_to_relaxed` from full x86 correctness. -/
theorem xcorrect_to_relaxed {n : Nat} {p : Program} (hn : n < 2 ^ 31 - 1) (h : XCorrect n p) :
    RelaxedCorrect n p
```

### `relaxed_iff_abs` (SortProof/Relax.lean)
```lean
/-- The relaxed model equals the T-machine. -/
theorem relaxed_iff_abs {n : Nat} {p : Program} : RelaxedCorrect n p ↔ ∀ x, AbsOK n p x
```

### `register_bound` (SortProof/Rename.lean)
```lean
/-- Register-bound lemma. -/
theorem register_bound {n : Nat} {p : Program} (hn : 2 ≤ n) (h : RelaxedCorrect n p) :
    let p'
```

### `relaxed_pad` (SortProof/Rename.lean)
```lean
theorem relaxed_pad {n : Nat} {p : Program} (m : Nat) (h : RelaxedCorrect n p) :
    RelaxedCorrect n (pad p m)
```

### `lower_bound_chain` (SortProof/Rename.lean)
```lean
/-- Lower-bound chain. Hypothesis = what the SAT/enumeration search checks: no program of
  length exactly `k` over the registers `0..n+k-1` with opcodes in `iset` is correct in the
  relaxed model. Conclusion: no program of length `≤ k` (any registers) with opcodes in `iset`
  is correct on x86 (all 32-bit inputs, all garbage, all flag states). -/
theorem lower_bound_chain (n k : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ p : Program, p.length = k → Program.WF (n + k) p → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedCorrect n p) :
    ∀ p : Program, p.length ≤ k → (∀ i ∈ p, i.inSet iset) → ¬ XCorrect n p
```

### `xsnap_to_relaxed` (SortProof/Snap.lean)
```lean
/-- Relaxation lemma for RS. -/
theorem xsnap_to_relaxed {n : Nat} {p : Program} {o : Snap} (hn : n < 2 ^ 31 - 1)
    (h : XSnap n p o) : RelaxedSnap n p o
```

### `relaxed_snap_has_cmp` (SortProof/Snap.lean)
```lean
theorem relaxed_snap_has_cmp {n : Nat} {p : Program} {o : Snap} (hn : 2 ≤ n)
    (h : RelaxedSnap n p o) : ∃ i ∈ p, i.isCmp = true
```

### `register_bound_snap` (SortProof/Snap.lean)
```lean
/-- Register-bound lemma for RS: registers `< n + k`, snapshot positions `≤ k`. -/
theorem register_bound_snap {n : Nat} {p : Program} {o : Snap} (hn : 2 ≤ n) (h : RelaxedSnap n p o) :
    let p'
```

### `lower_bound_chain_snap` (SortProof/Snap.lean)
```lean
/-- Lower-bound chain for RS. Hypothesis = the search: no program of length exactly `k` on
  registers `< n + k`, with snapshots on registers `< n + k` at positions `≤ k`, opcodes in
  `iset`, is relaxed-correct. Conclusion: no program of length `≤ k` (any registers, any
  snapshots) with opcodes in `iset` is RS-correct on x86. -/
theorem lower_bound_chain_snap (n k : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedSnap n p o) :
    ∀ (p : Program) (o : Snap), p.length ≤ k → (∀ i ∈ p, i.inSet iset) → ¬ XSnap n p o
```

### `checkStrictO_sound` (SortProof/Checker.lean)
```lean
theorem checkStrictO_sound {n : Nat} {o : Nat → Nat} {p : Program} (h : checkStrictO n o p = true) :
    StrictCorrectO n o p
```

### `checkStrict_x86` (SortProof/Checker.lean)
```lean
theorem checkStrict_x86 {n : Nat} {p : Program} (h : checkStrict n p = true) : XCorrect n p
```

### `alphadev_sort3_x86` (SortProof/AllPrograms.lean)
```lean
theorem alphadev_sort3_x86 : XCorrectO 3 alphadev_sort3.outReg alphadev_sort3.prog
```

### `alphadev_sort4_x86` (SortProof/AllPrograms.lean)
```lean
theorem alphadev_sort4_x86 : XCorrectO 4 alphadev_sort4.outReg alphadev_sort4.prog
```

### `alphadev_sort5_x86` (SortProof/AllPrograms.lean)
```lean
theorem alphadev_sort5_x86 : XCorrectO 5 alphadev_sort5.outReg alphadev_sort5.prog
```

### `reps_card` (SortProof/Checks.lean)
```lean
/-- One representative per weak order type: Fubini numbers 1, 3, 13, 75, 541. -/
theorem reps_card : (reps 1).length = 1 ∧ (reps 2).length = 3 ∧ (reps 3).length = 13 ∧
    (reps 4).length = 75 ∧ (reps 5).length = 541
```

### `sortsOK_rank_lt` (SortProof/SortFacts.lean)
```lean
theorem sortsOK_rank_lt {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) {j : Nat} (hj : j < n) :
    cnt x (y j) n ≤ j
```

### `sortsOK_rank_le` (SortProof/SortFacts.lean)
```lean
theorem sortsOK_rank_le {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) {j : Nat} (hj : j < n) :
    j < cnt x (y j + 1) n
```

### `MMInstr` (SortProof/L5.lean)
```lean
/-- MM-1 operand rules for one instruction. -/
def MMInstr (n : Nat) : Instr → Prop
  | .mov d s => ¬ (d < n ∧ s < n)
  | .cmp a b => n ≤ a ∧ n ≤ b
  | .cmov _ d s => n ≤ d ∧ n ≤ s
```

### `MMProg` (SortProof/L5.lean)
```lean
/-- MM program (theory's statement: `∀ i ∈ q, match i with ...`, here via `MMInstr`). -/
def MMProg (n : Nat) (q : Program) : Prop
```

### `l5` (SortProof/L5.lean)
```lean
/-- Lemma L5 (relaxed form). -/
theorem l5 {n : Nat} {q : Program} (hn : 2 ≤ n) (hq : MMProg n q) (h : RelaxedCorrect n q) :
    ∃ (p : Program) (o : Snap), p.length + 2 * n ≤ q.length ∧
      (∀ iset : Cond → Bool, (∀ i ∈ q, i.inSet iset) → ∀ i ∈ p, i.inSet iset) ∧ RelaxedSnap n p o
```

### `relaxed_chain_snap` (SortProof/L5.lean)
```lean
/-- The relaxed half of `lower_bound_chain_snap`. -/
theorem relaxed_chain_snap (n k : Nat) (iset : Cond → Bool) (hn : 2 ≤ n)
    (H : ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedSnap n p o) :
    ∀ (p : Program) (o : Snap), p.length ≤ k → (∀ i ∈ p, i.inSet iset) → ¬ RelaxedSnap n p o
```

### `mm_lower_bound` (SortProof/L5.lean)
```lean
/-- Main theorem (MM, AlphaDev counting). Hypothesis = the rule-free RS search at length `K`
  (registers `< n + K`, snapshots `reg < n + K`, positions `≤ K`, opcodes in `iset`, relaxed).
  Conclusion: no MM program (cells `0..n-1`, MM-1) of length `≤ K + 2n`, opcodes in `iset`,
  sorts on x86 (all 32-bit inputs, all garbage, all flag states). -/
theorem mm_lower_bound (n K : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ (p : Program) (o : Snap), p.length = K → Program.WF (n + K) p →
      (∀ j, (o j).1 < n + K) → (∀ j, (o j).2 ≤ K) → (∀ i ∈ p, i.inSet iset) →
      ¬ RelaxedSnap n p o) :
    ∀ q : Program, MMProg n q → q.length ≤ K + 2 * n → (∀ i ∈ q, i.inSet iset) → ¬ XCorrect n q
```

### `isMAD_MMProg` (SortProof/Results.lean)
```lean
theorem isMAD_MMProg {n : Nat} {p : Program} (h : p.isMAD n = true) : MMProg n p
```

### `alphadev_mm` (SortProof/Results.lean)
```lean
/-- Upper bound in MM: the AlphaDev memory programs are MM programs (MM-1) of length 17 / 28 / 42
  and sort on x86 (all inputs, garbage, flags). -/
theorem alphadev_mm :
    (MMProg 3 sort3.prog ∧ sort3.prog.length = 17 ∧ XCorrect 3 sort3.prog) ∧
    (MMProg 4 sort4.prog ∧ sort4.prog.length = 28 ∧ XCorrect 4 sort4.prog) ∧
    (MMProg 5 sort5.prog ∧ sort5.prog.length = 42 ∧ XCorrect 5 sort5.prog)
```

### `sort3_optimal_of` (SortProof/Results.lean)
```lean
/-- The shape of the final AlphaDev optimality claim, for n = 3 in I1: if the rule-free RS search
  at k = 10 (registers < 13) finds nothing, then no MM program of length ≤ 16 sorts on x86,
  so AlphaDev's 17 is optimal. `lean-lrat` / `lean-reflect` supply `H`. -/
theorem sort3_optimal_of
    (H : ∀ (p : Program) (o : Snap), p.length = 10 → Program.WF (3 + 10) p →
      (∀ j, (o j).1 < 3 + 10) → (∀ j, (o j).2 ≤ 10) → (∀ i ∈ p, i.inSet (fun _ => true)) →
      ¬ RelaxedSnap 3 p o) :
    ∀ q : Program, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q
```

### `l5_sim` (SortProof/L5Strict.lean)
```lean
/-- The translated program's snapshots equal the final cells of `q`, for every initial state. -/
theorem l5_sim {n : Nat} {q : Program} (hq : MMProg n q) (init : State Int) :
    ∀ j < n, snapOut (l5prog n q).out (l5prog n q).snap init j = (run compare q init).regs j
```

### `l5_strict_int` (SortProof/L5Strict.lean)
```lean
/-- Strict L5 over unbounded `Int` values. -/
theorem l5_strict_int {n : Nat} {q : Program} (hn : 2 ≤ n) (hq : MMProg n q) (h : StrictCorrect n q) :
    ∃ (p : Program) (o : Snap), p.length + 2 * n ≤ q.length ∧
      (∀ iset : Cond → Bool, (∀ i ∈ q, i.inSet iset) → ∀ i ∈ p, i.inSet iset) ∧ StrictSnap n p o
```

### `l5_strict` (SortProof/L5Strict.lean)
```lean
/-- Strict L5 on x86 (theory's statement). -/
theorem l5_strict {n : Nat} {q : Program} (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1) (hq : MMProg n q)
    (h : XCorrect n q) :
    ∃ (p : Program) (o : Snap), p.length + 2 * n ≤ q.length ∧
      (∀ iset : Cond → Bool, (∀ i ∈ q, i.inSet iset) → ∀ i ∈ p, i.inSet iset) ∧ XSnap n p o
```

### `mm_lower_bound_strict` (SortProof/L5Strict.lean)
```lean
/-- Strict-route chain to MM: a strict RS lower bound at K gives the MM bound K + 2n. -/
theorem mm_lower_bound_strict (n K : Nat) (iset : Cond → Bool) (hn : 2 ≤ n) (hn' : n < 2 ^ 31 - 1)
    (H : ∀ (p : Program) (o : Snap), p.length ≤ K → (∀ i ∈ p, i.inSet iset) → ¬ XSnap n p o) :
    ∀ q : Program, MMProg n q → q.length ≤ K + 2 * n → (∀ i ∈ q, i.inSet iset) → ¬ XCorrect n q
```

## Axioms (`lake env lean scratch/ax.lean`)
```
'SortProof.alphadev_sort3_x86' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.alphadev_sort4_x86' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.alphadev_sort5_x86' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.lower_bound_chain' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.lower_bound_chain_snap' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.x86_iff_reps' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.relaxed_iff_abs' depends on axioms: [propext, Quot.sound]
'SortProof.register_bound' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.register_bound_snap' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.checkStrictO_sound' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.reps_card' depends on axioms: [propext]
'SortProof.All.out_alphadev_sort5_42_suppG_out_x86' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.All.found_upper_sort5_I0_L42_mem_x86' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.l5' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.mm_lower_bound' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.alphadev_mm' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.sort3_optimal_of' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.l5_strict' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.l5_strict_int' depends on axioms: [propext, Classical.choice, Quot.sound]
'SortProof.mm_lower_bound_strict' depends on axioms: [propext, Classical.choice, Quot.sound]
```
