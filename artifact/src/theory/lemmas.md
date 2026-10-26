# Soundness lemmas for the trust chain (theory, v1, 2026-10-24)

Status: paper proofs, round 1. LaTeX-ready (math in `$...$`). Every lemma names the model it is about.
Owner: `theory`. Formal versions: `lean` (plan in `lean_plan.md`).

**Main result of this round (read first).** The register model in `shared/MODEL.md` v0 §1 (outputs fixed in $P_j$ at the end)
is **too strict** for the AlphaDev claim. An UNSAT result in it does **not** imply the AlphaDev bound.
The correct target model is **RS** (snapshot outputs, §0.3). Lemma L5 gives $L^{\min}_{\mathrm{MM}} = k^{\min}_{\mathrm{RS}} + 2n$.

---------------------------------------------------------------------------------------------------------------------

## 0. Definitions

### 0.1 Instructions and registers
Fix $n \ge 2$. A register set $\mathrm{Reg} = \{P_0,\dots,P_{n-1}\} \cup \{S_0, S_1, \dots\}$. One flag register $F$ with
values in $\{\mathsf{lt}, \mathsf{eq}, \mathsf{gt}\}$. Instruction set $I_0$ (Intel order, destination first, register operands only):

| instruction | reads | writes | effect |
|---|---|---|---|
| `mov D,S` | $S$ | $D$ | $D := S$ |
| `cmp A,B` | $A,B$ | $F$ | $F := \mathrm{cmp}(A,B)$ |
| `cmovl D,S` | $D,S,F$ | $D$ | if $F=\mathsf{lt}$ then $D:=S$ |
| `cmovg D,S` | $D,S,F$ | $D$ | if $F=\mathsf{gt}$ then $D:=S$ |

$I_1 = I_0 \cup \{$`cmovle`, `cmovge`$\}$ (fire on $F \in \{\mathsf{lt},\mathsf{eq}\}$ resp. $\{\mathsf{gt},\mathsf{eq}\}$).
**`spec` reports (2026-10-24) that AlphaDev's action space is $I_1$.** So the AlphaDev claim needs the lower bound in $I_1$.
A bound in $I_1$ implies the bound in $I_0$ (more programs), not conversely. All lemmas below hold for $I_0$ and $I_1$
unless marked.

Note: **a cmov reads its destination** (it keeps the old value when the condition is false). `mov` is the only
**full definition** of a register.

The abstract flag value covers all real x86 flag states: `cmovl` tests $SF\ne OF$, `cmovg` tests $ZF=0 \wedge SF=OF$;
`cmovle` tests $ZF=1 \vee SF\ne OF$, `cmovge` tests $SF=OF$. The four real states of $(SF\ne OF, ZF)$ map to
$\mathsf{lt}$ ($SF\ne OF$, any $ZF$), $\mathsf{eq}$ ($SF=OF, ZF=1$), $\mathsf{gt}$ ($SF=OF, ZF=0$), and all four conditions agree
with that map. So the abstract flag covers every real initial flag state, also for $I_1$.

A program is a word $p = i_1 \cdots i_k$ over $I_0$; its length is $|p| = k$. A **position** $t \in \{0,\dots,k\}$ is the
point after $i_t$ (position $0$ = start).

### 0.2 Semantics
- **Strict semantics** (the real claim). Input $x \in \mathbb{Z}_{32}^n$, garbage $g$ (any value for every $S_j$),
  initial flag $f \in \{\mathsf{lt},\mathsf{eq},\mathsf{gt}\}$. $P_i$ starts as $x_i$, $S_j$ as $g_j$, $F$ as $f$.
- **T-relaxed semantics** (`MODEL.md` §2). Only inputs with $x_i < \mathrm{INT\_MAX}$; every $S_j$ starts as
  $T := \mathrm{INT\_MAX}$; $F$ starts as $\mathsf{eq}$. This is one instance of the strict semantics.

### 0.3 Output conventions (three register models)
$\mathrm{sort}_j(x)$ = the $j$-th smallest entry of $x$ (by value).
- **RF** (fixed, `MODEL.md` v0): at position $k$, $P_j = \mathrm{sort}_j(x)$ for all $j$.
- **RE** (free at end): the program also names registers $r_0,\dots,r_{n-1}$; at position $k$, $r_j = \mathrm{sort}_j(x)$.
- **RS** (snapshot): the program also names pairs $(r_j, t_j)$, $t_j \in \{0..k\}$; the value of $r_j$ at position $t_j$
  is $\mathrm{sort}_j(x)$. The pairs are part of the program: the same for all inputs.

Every RF program is an RE program, every RE program is an RS program, with the same length. So
$k^{\min}_{\mathrm{RS}} \le k^{\min}_{\mathrm{RE}} \le k^{\min}_{\mathrm{RF}}$, and a **lower bound for RS is the strongest**.
$k^{\min}_{\mathrm{RE}} = k^{\min}_{\mathrm{RS}}$ is **not proved** (a snapshot of a register that is changed later costs a
`mov` in RE). Evidence that RF differs in practice: every AlphaDev register core (`programs/out/*`) is correct in RE and RS but
not in RF (`agents/theory/check.py`); e.g. sort3_17 ends with outputs in $(P_0, S_{11}, P_1)$.

### 0.4 Memory model MM (AlphaDev's setting, to be confirmed by `spec`)
Memory slots $m_0..m_{n-1}$ hold $x$ at the start and must hold $\mathrm{sort}(x)$ at the end. Registers: unbounded,
all garbage at the start. Instructions: $I_0$ on registers, plus load `mov r,[m]` and store `mov [m],r`.
**Assumption MM-1:** no memory operand in `cmp`/`cmov`, no memory-to-memory move (x86 has none). Extra spill slots are
allowed (they change nothing below). Length counts loads and stores.

---------------------------------------------------------------------------------------------------------------------

## L1. Order-type lemma (and the test-subset lemma)

Let $\mathcal{W}_n$ be the set of weak orders (ordered set partitions) of $\{0..n-1\}$. The type of $x$ is
$\tau(x) \in \mathcal{W}_n$: $i \sim j$ iff $x_i = x_j$, blocks ordered by value.
$|\mathcal{W}_n|$ = Fubini number: $1, 1, 3, 13, 75, 541, 4683$ for $n = 0..6$ (computed:
$a_m = \sum_{j=1}^{m} \binom{m}{j} a_{m-j}$). So 13 / 75 / 541 for $n = 3/4/5$. **Confirmed.**

**Abstract semantics.** A register holds a *label* $\ell \in \{0..n-1\} \cup \{T\}$. For a weak order $w$, compare
labels by $w$, with $T$ above all labels and **$\mathrm{cmp}(T,T) = \mathsf{eq}$**. Run the program on labels with flags from these comparisons.

**Lemma L1.** Fix any of RF/RE/RS, T-relaxed semantics. Let $x$ have type $w$ and all $x_i < \mathrm{INT\_MAX}$. Then at every
position, every register holds $v_x(\ell)$, where $\ell$ is the label that the abstract run on $w$ gives that register,
and $v_x(i) = x_i$, $v_x(T) = \mathrm{INT\_MAX}$. The flag equals the abstract flag. Hence $p$ is correct on $x$ iff
$p$ is abstractly correct on $w$, i.e. each output label $\ell \ne T$ and $\ell$ lies in the block of $w$ that holds
rank $j$.

*Proof.* Induction on positions. Position 0: $P_i$ holds $x_i = v_x(i)$, $S_j$ holds $\mathrm{INT\_MAX} = v_x(T)$, flag $\mathsf{eq}$
both sides. Step: `mov` copies, so the claim is kept. `cmp A,B`: the concrete values are $v_x(\ell_A), v_x(\ell_B)$ and
$v_x(\ell_A) < v_x(\ell_B)$ iff $\ell_A <_w \ell_B$, because $w = \tau(x)$ and $x_i < \mathrm{INT\_MAX}$ (this is the only
place where the bound on $x$ is used). Same for $=$, $>$. `cmov`: the same flag on both sides, so the same branch.
Output: $v_x(\ell) = \mathrm{sort}_j(x)$ iff $\ell \ne T$ (else the value is INT_MAX, larger than every input) and
$x_\ell = \mathrm{sort}_j(x)$, which depends only on $w$. $\square$

**Corollary L1a.** $p$ is T-relaxed correct on all admissible inputs iff it is abstractly correct on all $w \in \mathcal{W}_n$.
(Each $w$ has a representative with values in $\{0..n-1\}$, so it is admissible.)

**Lemma L1b (test subset, CEGIS).** For any $W \subseteq \mathcal{W}_n$: if no program of length $k$ is abstractly correct
on $W$, then no program of length $k$ is abstractly correct on $\mathcal{W}_n$. *Proof:* correctness on $\mathcal{W}_n$
implies correctness on $W$. $\square$
Consequences: (i) a lower bound may use only the $n!$ strict orders, or a CEGIS subset; (ii) an **upper bound** (judge)
must use all of $\mathcal{W}_n$ (ties change `cmov` behaviour: with $\mathsf{eq}$ neither `cmovl` nor `cmovg` fires).

---------------------------------------------------------------------------------------------------------------------

## L2. Relaxation lemma

**Lemma L2.** If $p$ is strictly correct (all $x$, $g$, $f$) in RF/RE/RS, then $p$ is T-relaxed correct.

*Proof.* The T-relaxed run on admissible $x$ is the strict run with $g_j = \mathrm{INT\_MAX}$ for all $j$ and $f = \mathsf{eq}$.
Realizability: $\mathrm{INT\_MAX}$ is a legal 32-bit value; $f=\mathsf{eq}$ is the real state $ZF=1, SF=OF$; inputs below
INT_MAX are legal inputs. Strict correctness holds for this instance. $\square$

Checks asked by the brief:
1. *$T >$ all inputs is realizable:* yes, by restricting inputs to $x_i \le \mathrm{INT\_MAX}-1$. This restriction only makes
   the relaxed claim weaker on the input side, so the lower bound stays sound. $T$ vs $T$ is $\mathsf{eq}$ (INT_MAX = INT_MAX);
   **encoders must implement $\mathrm{cmp}(T,T) = \mathsf{eq}$**, not $\mathsf{lt}$/$\mathsf{gt}$.
2. *Output $T$ = wrong:* yes, INT_MAX is larger than every admissible input.
3. *Can a program that reads garbage be correct?* In the strict model, yes, trivially: a dead read (`mov S0,S1` with S0
   dead; a `cmp` on garbage whose flags are never read). Whether a **shortest** strict-correct program can need a garbage
   read is open (Q-G below). It does not matter for soundness (L2 covers every program), only for completeness:
4. *Completeness risk (not a soundness risk).* In the T-relaxed model, $T$ acts as a known $+\infty$ sentinel. A register that
   holds $T$ or $x_i$ depending on an earlier comparison can carry extra information. So $k^{\min}$ (relaxed) may be **smaller**
   than the real optimum. Then the lower bound is not refuted, it is just not proved. Remedy (still sound): require correctness
   in several realizable instances together, e.g. scratch $= +\infty$ (INT_MAX, inputs < INT_MAX) **and** scratch $= -\infty$
   (INT_MIN, inputs > INT_MIN), and initial flag $\in \{\mathsf{lt},\mathsf{eq},\mathsf{gt}\}$. Each instance is one strict instance,
   so L2 holds for the conjunction. Use it only if a relaxed program shorter than AlphaDev's is found and the judge rejects it.

**Q-G (open, low priority).** Is the strict optimum equal to the optimum over programs that never read a register before
writing it and never read flags before a `cmp`? Not needed for any lower bound in this project.

**Judge note (upper bound).** In the strict model, behaviour depends on the joint type of $(x, g)$ and on $f$. A sufficient
check: (a) syntactic: no read of $S_j$ before its first `mov` definition, no `cmov` before the first `cmp`; then
(b) all $w \in \mathcal{W}_n$. If (a) fails, enumerate the joint weak orders of $(x, g_{\text{read}})$ and all 3 flags.

---------------------------------------------------------------------------------------------------------------------

## L3. $R = n + k$ is without loss of generality

**Lemma L3.** In RF/RE/RS, T-relaxed, $n \ge 2$: if a correct program $p$ of length $k$ uses any register set, then a correct
program of length $k$ uses only $P_0..P_{n-1}, S_0..S_{k-1}$.

*Proof.* (a) $p$ has at least one `cmp`: otherwise $F = \mathsf{eq}$ always, every `cmovl`/`cmovg` is a no-op and every
`cmovle`/`cmovge` acts as `mov`, so every register's label is a
constant independent of $w$, so output $0$ has a constant label $c$; take $w$ in which $c$ is not the minimum (exists, $n\ge2$);
contradiction. (b) So at most $k-1$ instructions write a register, so at most $k-1$ scratch registers are written.
(c) A scratch register that is never written holds $T$ at every position, for every input. Replace all such registers by one
name $U$: every read gives the same value $T$, so the run is unchanged. (d) Rename the $\le k-1$ written scratch registers and
$U$ bijectively to $S_0..S_{k-1}$. A bijective scratch renaming keeps the relaxed run (all scratch start equal). $\square$

Remark: in the **strict** model (c) fails (distinct garbage). L3 is used only inside the relaxed model, which is enough.
Remark: real x86-64 has 16 GPRs. A lower bound for unbounded registers implies the bound for 16. The upper-bound program
must fit in real registers (AlphaDev's does; `spec` to confirm).

---------------------------------------------------------------------------------------------------------------------

## L4. Padding and monotonicity

Let $E_k$ = "there is a program of length **exactly** $k$, correct on $W$, with $R = n + k$, satisfying rule set $\mathcal{R}$".

**Lemma L4a (no rules).** If $\mathcal{R} = \emptyset$ and $E_k$ is UNSAT, then $E_{k'}$ is UNSAT for all $k' \le k$.
*Proof.* Append $k-k'$ copies of `mov P0,P0` (a no-op); registers $n+k' \le n+k$. $\square$

**Lemma L4b (rules break padding).** With the rules of L6 (no `mov r,r`, no dead writes, every `cmp` read, ...) **no** padding
instruction is allowed, so $E_k$ is in general **not** monotone in $k$. Two correct options:
- **Sweep:** prove $E_k$ UNSAT for **every** $k \in \{0, \dots, K\}$. Then no correct program of length $\le K$ exists
  (proof: a shortest one has length $m^\ast \le K$ and, by L6, satisfies $\mathcal{R}$, so $E_{m^\ast}$ is SAT).
- **NOP suffix:** add an opcode `nop` (identity), constraint "`nop` at $t$ $\Rightarrow$ `nop` at $t+1$", and apply every rule
  to the non-`nop` prefix only ("next `cmp` or end" means end of the prefix). One UNSAT at $K$ then covers all $\le K$.
**Which one each claim uses must be stated in the claim.** Small $k$ are cheap, so the sweep is the default.

---------------------------------------------------------------------------------------------------------------------

## L5. Counting map: memory model MM $\to$ register model RS

**Lemma L5.** Under MM-1, T-relaxed (or strict) semantics: if an MM program of length $L$ is correct, then an RS program of
length $\le L - 2n$ is correct. Conversely an RS program of length $k$ gives an MM program of length $k+2n$.
Hence $L^{\min}_{\mathrm{MM}} = k^{\min}_{\mathrm{RS}} + 2n$, in the strict semantics and in the T-relaxed semantics
separately (both maps are simulations for every initial register/flag state: fresh registers are written before they are read).
The main theorem uses only "$\ge$" in the relaxed semantics.

*Proof.* Let $q$ be a correct MM program.

(1) *Every slot $i$ is loaded before its first store.* Only loads read slots (MM-1). If slot $i$ is not loaded before its
first store (or never), $x_i$ never reaches a register, so the final memory does not depend on $x_i$. Take $x, x'$ that differ
only in $x_i$ with different multisets; the sorted outputs differ. Contradiction.

(2) *Every slot $j$ is stored at least once.* Otherwise $m_j$ ends as $x_j \ne \mathrm{sort}_j(x)$ for some $x$ ($n\ge2$).

(3) *Segments.* For slot $i$, the stores to $i$ cut time into segments; segment $0$ (before the first store) has value $x_i$;
segment $s \ge 1$ has the value stored by the $s$-th store. All loads in one segment read the same value.
Give each segment a fresh register $G_{i,s}$, with $G_{i,0} := P_i$.

(4) *Translation.* Process $q$ left to right:
- non-memory instruction: copy it.
- store opening segment $s$ of slot $i$: if the segment has no load and is not the last segment: delete (dead store).
  If it is the last segment of slot $i$ and has no load: delete, and set snapshot $(r_i,t_i)$ := (current name of the source
  register, current position). Else: emit `mov G_{i,s}, r`; if it is the last segment also set the snapshot to $(r, \text{here})$.
- load in segment $s$ of slot $i$ that is **not** the last load of the segment: emit `mov r, G_{i,s}`.
- the **last** load `mov r,[m_i]` of segment $s$: delete it, and rename $r$ to $G_{i,s}$ on the live range of this definition
  (from here to the next full definition of $r$ — a `mov` or load into $r$ — exclusive, or to the end; `cmov` into $r$ stays in
  the range).

(5) *Correctness of the translation.* $G_{i,s}$ is written only at its segment's store (or holds $x_i$ from the start for
$s=0$) and, after the last load, only inside the renamed range; it is read before the last load only by copies of earlier
loads of the same segment. So each emitted copy reads the segment value, and at the last load $G_{i,s}$ holds exactly the value
the load would give. The renamed range uses a name not used elsewhere after that point. Ranges of the same original register
do not overlap (a load into $r$ ends the previous range). So the RS run simulates the MM run, and snapshot $i$ equals the
value of the final store into $m_i$, i.e. $\mathrm{sort}_i(x)$.

(6) *Count.* Per slot: segment 0 has a load (by (1)) and its last load is deleted: $-1$. The last segment: its store is deleted
(no load) or its last load is deleted ($-1$ either way); by (2) the last segment is a stored segment, distinct from segment 0.
Other segments: never cost more than in $q$. Total $\le L - 2n$.

(7) *Converse.* Emit `mov P_i,[m_i]` for all $i$ first ($n$), then the RS program, and `mov [m_j], r_j` right after position
$t_j$ ($n$). Slots are not read again, so early stores are safe. $\square$

Machine check of the construction: `agents/theory/l5map.py` implements exactly this translation (independent of spec's
ad2out.py). On all memory programs in `programs/` and `programs/found/` it gives $k \le L-2n$ and the result passes
`check.py` (relaxed and strict) — e.g. SI Sort3_19 maps to 13 = L-2n (ad2out gives 14: it keeps the last reload).

Notes for `spec` (L5 inputs to confirm):
- `spec` (2026-10-24): AlphaDev counts every instruction incl. $n$ loads + $n$ stores; `cmp`/`cmov` only on registers
  (MM-1 holds); lengths 17/28/42. So the targets are $k_{\mathrm{RS}} \ge 11, 20, 32$, i.e. UNSAT for all $k \le 10, 19, 31$.
  `spec` derived the same map independently (its "M_out" = RS). Its sketch uses one copy register per cell; that is wrong if a
  cell is stored and reloaded twice (the renamed range of the first reload can reach past the second store). Use one fresh
  register **per segment**, as in (3).
- If AlphaDev's action space allowed `cmp r,[m]` or `cmovcc r,[m]`, MM-1 fails and a load can merge into a compare; then L5
  is false as stated and needs a new model. **Must be checked against the AlphaDev paper / code.**
- If AlphaDev's length does not count loads/stores, replace $2n$ by $0$ and the target is still RS (loads choose free target
  registers and stores free sources).
- "Loads first / stores last" is **not** needed: L5 handles any interleaving, any reload, any spill.
- Fixing both input and output registers (RF) is **not** WLOG: MM picks load targets and store sources freely. By renaming one
  can fix the inputs ($P_i$) **or** the outputs, not both.
- AlphaDev listings use AT&T-like order (`mov A B` may mean $B := A$). Parse with care.

---------------------------------------------------------------------------------------------------------------------

## L6. Symmetry breaking and pruning rules

All rules are about the **T-relaxed RS** model (or RF/RE, where said) with $R = n+k$. Two kinds:
- **S-rules** (minimality rules): hold for **every** shortest correct program.
- **D-rules** (dominance rules): hold for **one** chosen shortest correct program: the lex-least one in its class.

### L6.0 Master lemma (joint soundness)

Fix one total order $\prec$ on instructions: lexicographic on (opcode, operand 1, operand 2) with a fixed opcode order and
register order $P_0 \prec \dots \prec P_{n-1} \prec S_0 \prec S_1 \prec \dots$ (any fixed order works if **all** rules use the
same one). Extend $\prec$ to programs of equal length lexicographically, ties broken by the snapshot list.

Operations (each maps a correct length-$k$ program to a correct length-$k$ program over the same registers):
- $\rho_\pi$: permute scratch names. Correct: all scratch start as $T$.
- $\iota_\pi$ (**RS / RE only**): permute $P$ names (and snapshot registers). Correct: the new program on $x$ acts as the old
  one on $x \circ \pi$, and $\mathrm{sort}(x\circ\pi) = \mathrm{sort}(x)$. **Not valid in RF** (outputs are bound to $P_j$).
- $\sigma_t$: swap $i_t, i_{t+1}$ when *swappable* = Bernstein-independent (no write of one meets a read or write of the other;
  $F$ counts as a register; cmov reads its destination). In RS also move each snapshot $(r, t)$ at the middle point:
  if $r \in W(i_t)$ to $(r, t+1)$; if $r \in W(i_{t+1})$ to $(r, t-1)$; else keep. Correct: the state after both is the
  same; a moved snapshot reads the same value (the other instruction does not write $r$). So **no snapshot condition is
  needed in the encoding** (snapshot positions are free variables).
- $\phi_t$: if $i_t$ = `cmp A,B`, replace it by `cmp B,A` and swap `cmovl`$\leftrightarrow$`cmovg` in the block up to the next
  `cmp` (and `cmovle`$\leftrightarrow$`cmovge` for $I_1$). Correct: the flag in that block is mirrored.
- $\mu$ ($I_1$ only, applied **once, before** taking the closure): replace every `cmovle`/`cmovge` before the first `cmp`
  by `mov` with the same operands. Correct: $F = \mathsf{eq}$ there. No other operation creates a pre-`cmp` cmov
  ($\sigma$ never moves a cmov across a `cmp`, both touch $F$; $\rho,\iota$ keep opcodes; $\phi$ acts after a `cmp`).
  (Argument from `sat2` RULES.md; it needs no opcode-order condition.)

**Lemma L6.0.** Let $p$ be a shortest correct program. Let $C(p)$ be the closure of $\{p\}$ under these operations and
$p^\ast = \min_\prec C(p)$ (finite set, so it exists). Then $p^\ast$ is shortest and correct, and for every operation $g$
applicable to $p^\ast$, $g(p^\ast) \not\prec p^\ast$. Hence $p^\ast$ satisfies **all** D-rules below at once, and all S-rules
(it is shortest).
*Proof.* Immediate from minimality and closure. $\square$

**Principle.** An encoding may enforce any set of conditions that $p^\ast$ provably satisfies. It must not enforce a condition
that uses a different order, a different operand scan order, or a different definition of "independent".

### L6.1 D-rules

**R1 (canonical scratch naming).** Scan operands in the order used by $\prec$ (instruction by instruction, operand 1 then
operand 2). The first occurrences of scratch names appear in the order $S_0, S_1, S_2, \dots$ (no gaps).
*Proof.* If $S_a$ occurs first and $a > b$ with $S_b$ later or absent, $\rho_{(a\,b)}$ changes nothing before that operand and
puts $S_b \prec S_a$ there: lex-smaller. $\square$
*Pitfall:* an instruction with **two** new names. For scratch this does not occur in a shortest program (both hold $T$: `mov`
is a no-op, `cmov` is a no-op, `cmp` gives $\mathsf{eq}$, see S5). For $P$ names (R6) it **does** occur (`cmp P3,P4`), so the
operand scan order must match $\prec$ exactly. The common SAT form "$S_{j+1}$ used at step $t$ $\Rightarrow$ $S_j$ used at a step
$\le t$" is implied by R1, so it is sound.

**R2 (adjacent order).** If $i_t, i_{t+1}$ are swappable then $i_t \prec i_{t+1}$.
*Proof.* Else $\sigma_t$ gives a lex-smaller program. Identical instructions are never swappable (same written register or both
write $F$), so strict $\prec$ is right. $\square$
Stronger sound option (Anisimov–Knuth lexicographic normal form): no factor $b\,u\,a$ with $a \prec b$ and $a$ swappable with $b$
and with every letter of $u$. Only the adjacent form is required.

**R5 (cmp orientation, optional).** Every `cmp A,B` has $A \prec B$. *Proof:* $\phi_t$ changes position $t$ first. $\square$

**R6 (canonical input naming, RS/RE only).** First occurrences of $P$ names appear in order $P_0, P_1, \dots$.
*Proof:* as R1 with $\iota$. $\square$ (Gives up to $n!$ extra pruning. **Unsound in RF.**)

**R7 ($I_1$, pre-`cmp` cmovs).** No `cmovle`/`cmovge` before the first `cmp`.
*Proof:* take $p^\ast = \min C(\mu(p))$; every member of $C(\mu(p))$ has no pre-`cmp` cmov (see $\mu$). $\square$
(`cmovl`/`cmovg` there are covered by S4.) Lemma L6.0 holds with $C(\mu(p))$ in place of $C(p)$.

### L6.2 S-rules
General argument: if an instruction can be deleted and the result is correct, the program was not shortest.
"Dead" is syntactic: a write of $D$ at $t$ is **dead** if $D$ is not read (by an instruction, including as a `cmov`
destination, or by a snapshot in RS, or as a final output in RF/RE) before the next full definition of $D$ or the end.
A `cmp` at $t$ is **dead** if no `cmov` lies between it and the next `cmp` (or end).

- **S1** no `mov D,D`, no `cmovX D,D` (no-ops).
- **S2** no dead write. *Proof:* deleting it changes $D$ only where $D$ is not read. $\square$
- **S3** every `cmp` is followed by at least one `cmov` before the next `cmp` / end. *Proof:* dead `cmp`. $\square$
- **S4** no `cmovl`/`cmovg` before the first `cmp`. *Proof:* initial $F = \mathsf{eq}$, so it is a no-op.
  **For $I_1$:** `cmovle`/`cmovge` before the first `cmp` is **not** a no-op (it acts as `mov`). The rule "no cmov of any kind
  before the first `cmp`" is a **D-rule** via $\mu_t$, sound only if the opcode order has `mov` $\prec$ `cmovle`, `cmovge`
  (R7 below). (With the multi-instance
  relaxation of L2.4, delete **all** pre-`cmp` cmovs at once: the result acts in every instance as the old program in instance
  $\mathsf{eq}$. Still sound.) $\square$
- **S5** no `cmp A,A`. *Proof:* the flag is $\mathsf{eq}$; in its block `cmovl`/`cmovg` are no-ops (delete) and
  `cmovle`/`cmovge` act as `mov` (replace); then the `cmp` is dead (delete): strictly shorter. $\square$

**Joint soundness of S- and D-rules.** S-rules hold for every shortest program, $p^\ast$ is shortest, so $p^\ast$ satisfies all.
Conditions: (i) applies at $k = m^\ast$ (the sweep or the NOP-suffix of L4b); (ii) S-rules must be **syntactic**, never
"deletable on the current CEGIS test set"; (iii) the CEGIS subset only removes constraints (L1b), so it does not interact.

**R6 with sat2's R1'/R2'/R3.** Compatible: take the lex-least element of $\{\mathrm{canon}(Q) : Q \in C_{\sigma,\iota}(\mu(p))\}$
(canon = sat2's first-write scratch renaming + T-read redirection). $\iota$ commutes with canon (it renames only $P$, positions
unchanged) and with $\sigma$ (independence does not depend on names). A violation of R3 at the minimum gives a smaller element by
sat2's cases (i)/(ii); a violation of R6 gives a smaller element by $\iota_{(a\,b)}$. No re-canonicalization of $P$ after a swap
is needed: the swapped program is in the closure as it is. Scan order for R6 must be (dst, then src), as sat2's code compares
dst before src.

**Implied (semantic) constraints** hold for every correct program, so they combine with every rule. Example (sat2 `live`): for
each order type $e$, position $t$ and value $v$ of $e$: if some output $j$ with $\mathrm{sort}_j(e) = v$ is read at a position
$\ge t$ (RS: $t_j \ge t$; RF/RE: always), then some register holds $v$ at $t$. Proof: instructions only copy values, so a value
absent at $t$ is absent later. Sound.

### L6.3 Search-side pitfall (for `enum`)
State deduplication (keep one prefix per abstract state) is sound alone: the future depends only on the state (all labels for
all $w$, the flag per $w$, and in RS the set of outputs already captured). It is **not** automatically sound together with
syntactic rules that look at the prefix (R1, R2, R5, R6, S2, S3): the kept prefix may forbid the needed next instruction while
the dropped one allows it. Sound options: key the dedup on (state, rule-relevant syntax), or prove for each rule that the
dropped prefix can be replaced.

---------------------------------------------------------------------------------------------------------------------

## L8. Variant MM+ (memory source operands allowed) and the question $k_{\mathrm{out}} = k_{\mathrm{end}}$

**MM+**: as MM, but `cmp` may read a cell in either operand and `cmovcc r,[m]` may read a cell (x86-legal); cells are still
written only by stores. `upper` found MM+ programs with $L = 26$ (sort4) and $L = 40$ (sort5), shorter than AlphaDev's 28 / 42
(x86-checked). So MM-1 is essential for the AlphaDev claim.

**Lemma L8.** An MM+ program $q$ of length $L$ maps to an RS program of length $\le L - a - b$, where $a$ = #cells whose
segment 0 (before the first store) ends with a load as its last access, and $b$ = #cells whose final segment (after the last
store) has no access. In particular $L^{\min}_{\mathrm{MM+}} \ge k^{\min}_{\mathrm{RS}}$ only (no $+2n$).
*Proof.* As L5, with memory-source operands reading the segment register $G_{i,s}$ directly (no instruction). The last-load
renaming is valid only if no memory-operand read of the segment follows it (else the renamed range may change $G_{i,s}$
before that read); a final store is deletable only if no access follows it. $\square$
Consequence: an MM+ optimum needs its **own encoding** (cells = registers that cmp/cmov may read but only stores write,
outputs = cells at the end, loads/stores cost 1). L1–L3 carry over (cells are like $P$ registers); input symmetry does NOT
(outputs are fixed to cells) unless a snapshot lemma for MM+ is proved. Not needed for the main claim.

**$k_{\mathrm{out}}$ vs $k_{\mathrm{end}}$ (spec §4.3 open point).** Always $k_{\mathrm{out}} \le k_{\mathrm{end}}$. No general
equality lemma is needed: AlphaDev's register cores have all outputs valid at the end (checked: RE = True for all), so
$k_{\mathrm{end}} \le L_{AD} - 2n$; hence a proof of $k_{\mathrm{out}} \ge L_{AD} - 2n$ gives $k_{\mathrm{out}} = k_{\mathrm{end}}
= L_{AD} - 2n$ for that $n$. For $n = 3$ this holds now (enum + critic: $k_{\mathrm{out}}(3) = 11$).

## L7. Comparison lower bound (from `critic`, checked by theory)

**Lemma L7.** In T-relaxed RS (also RF/RE), $I_0$ or $I_1$: a program correct on the $n!$ permutations has
$\#\mathrm{cmp} \ge \lceil \log_2 n! \rceil$ (= 3, 5, 7 for $n$ = 3, 4, 5).
*Proof.* Labels as in L1. Call two permutations equivalent at position $t$ if all flags so far agree. Induction: equivalent
permutations have the same label in every register (mov/cmov act on labels and depend only on the flag). A `cmp A,B` compares
the same label pair on a whole class: equal labels (incl. $T,T$) give $\mathsf{eq}$ on the whole class; $T$ vs an index gives
$\mathsf{gt}$/$\mathsf{lt}$ on the whole class; two distinct indices give $\mathsf{lt}$ or $\mathsf{gt}$ (no ties on permutations).
So a `cmp` splits a class into $\le 2$ classes, cmovs do not split. At the end snapshot $j$ holds the label $\pi^{-1}(j)$, which
differs for different $\pi$, so all $n!$ classes are singletons: $2^{\#\mathrm{cmp}} \ge n!$. $\square$
(My earlier worry "three outcomes" was wrong: the eq outcome holds for the whole class, so it does not split.)
Note: the comparator-network bound (#cmp $\ge$ 9 for $n=5$) does NOT hold: `bounds` has a 7-cmp sort5 (fj5_7cmp.s).

## L9. Case splits (checklist for sort5 splits)

A split of one search into cases $C_1, \dots, C_m$ (each case = extra constraints) gives "no program" only if:
1. **Coverage for the chosen representative.** The cases must cover the program that the rules keep: the lex-least $p^\ast$
   (L6.0) or the rewriting normal form (sat). Covering "all programs" is NOT enough if the case predicate is not invariant under
   the canonicalization (e.g. "the first cmp is cmp P0,P1" is about names; after pcanon/R6 renaming it may change). Proof
   obligation: $\forall p^\ast$ satisfying the rules, $\exists i$, $p^\ast \in C_i$.
2. **Case predicates by symmetry.** If a case is removed "by symmetry" (e.g. by input relabelling or flag polarity), the
   symmetry used must be one of the operations in the same closure (L6.0) and the rule set must be proven jointly with it;
   otherwise prove the case separately.
3. **Same model in every case**: n, k (or ≤ k with sweep / NOP suffix), R = n + k, iset, output rule, relaxation, test set.
   A case with a smaller test set is fine (L1b).
4. **Implied constraints** (true for every correct program: #cmp ≥ 7, #cmov ≥ Huff, live, rule D) can be added to every case.
5. **Case-dependent bounds** (e.g. "after first cmp the remaining length ≥ h") must be lower bounds for a shortest completion
   from that case, and their proof must not use a rule that the case split already relies on in a different form.
6. **Certificates**: one UNSAT proof per case, plus a checked proof of coverage (a small CNF/Lean statement, or a paper proof).

## L10. Removing reads of uninitialised registers (enum's Lemma NG v3, checked by theory)

**Lemma L10 (strict model).** For every strict-correct program $P$ there is a strict-correct $P^\ast$ with
$|P^\ast| \le |P|$ in which the only read of a never-written register is a *garbage move* `mov A,B` with $A$, $B$ both
never accessed before.
*Proof.* Rewrite, in time order, each instruction that reads a never-written register $S$ at its first access $t$; choose the
garbage $g_S$ as a function of the input, the other garbage and the flags (allowed: $S$ is not accessed before $t$):
`cmovX S,E` → `mov S,E` ($g_S := E_t$); `cmovX E,S` → `mov S,E` ($g_S := E_t$); `mov D,S` → `mov S,D` ($g_S := D_t$);
`cmp X,S` → `mov S,X` and the block's cmovs rewritten for $\mathsf{eq}$ ($g_S := X_t$); `cmp S,S` → deleted + eq-rewrite;
two fresh operands in `cmp A,B` / `cmovX A,B` → `mov A,B` ($g_B := g_A$). With the chosen garbage the old and new runs agree
on every location that is read later; the new program never reads $g_S$, so it is correct for every $g_S$. $\square$
Use: in the relaxed set model a cmov into a $T$ register needs a garbage register (counter $\gamma$), which cuts the $n=4$
search about 100×. Also answers Q-G partly: useful garbage reads reduce to garbage moves. Claims that use it are about
strict-correct programs (the AlphaDev claim).

## The chain (theorem form)

**Theorem.** Fix $n$, $I \in \{I_0, I_1\}$, memory accessed only by `mov` loads/stores (MM-1, a model choice: x86 also
has `cmp r,m` and `cmovcc r,m`; AlphaDev's listings never use them), AlphaDev counting $C$ with loads and stores, unbounded registers. Suppose for every
$k \in \{0..L-1-2n\}$ the RS encoding $E_k$ (T-relaxed, test set $W \subseteq \mathcal{W}_n$, $R = n+k$, rules
$\subseteq$ {R1,R2,R5,R6,R7,S1–S5}) is UNSAT, with checked proofs. Then no x86 program in MM of length $\le L-1$ sorts all
$x \in \mathbb{Z}_{32}^n$ for all garbage and flags.

*Proof.* Suppose $q$ is one, length $L' \le L-1$. L2: $q$ is relaxed correct. L5: an RS relaxed correct program of length
$\le L'-2n$ exists; let $m^\ast$ be the least such length. L3: one exists with $R = n+m^\ast$. L6.0: one of them, $p^\ast$,
satisfies the rules. L1/L1a/L1b: $p^\ast$ is correct on $W$. So $E_{m^\ast}$ is SAT and $m^\ast \le L-1-2n$. Contradiction. $\square$

| link | statement | proof | formal (lean) | machine check |
|---|---|---|---|---|
| L2 | strict ⇒ T-relaxed | here | planned P1 | – |
| L5 | MM length $L$ ⇒ RS length $L-2n$ | here | planned P3 | – |
| L3 | $R = n+k$ suffices | here | planned P2 | – |
| L6 | rules keep one shortest program | here | planned P2 | VeriPB for R1/R5/R6 (optional) |
| L1 | order types suffice; subset is sound | here | planned P1 | – |
| L4 | sweep all $k$ / NOP suffix | here | P1 | – |
| encoding | CNF = $E_k$ | – | verified encoder (later) | – |
| solver | $E_k$ UNSAT | – | – | DRAT/LRAT + cake_lpr |

---------------------------------------------------------------------------------------------------------------------

## Appendix A. Rule statements in formal style (for `lean`, `lean-reflect`, `coq`)

Types. `Reg := P (i : Fin n) | S (j : Fin s)`; `Op := mov | cmp | cmovl | cmovg | cmovle | cmovge`;
`Instr := (op : Op) (a b : Reg)` (a = destination, or first cmp operand); `Prog := List Instr`;
RS program = `(p : Prog) (out : Fin n → Reg × Fin (p.length + 1))`.
`W : Instr → Finset Loc`, `Rd : Instr → Finset Loc`, `Loc := reg Reg | flags`:
  `W (mov,a,b) = {a}`, `Rd (mov,a,b) = {b}`; `W (cmp,a,b) = {flags}`, `Rd (cmp,a,b) = {a,b}`;
  `W (cmovX,a,b) = {a}`, `Rd (cmovX,a,b) = {a,b,flags}`.
`indep x y := Disjoint (W x) (Rd y ∪ W y) ∧ Disjoint (W y) (Rd x)`.
Order: `Op` order mov < cmp < cmovl < cmovg < cmovle < cmovge (any fixed order is fine); `Reg` order P 0 < … < P (n-1) < S 0 < …;
`Instr` order lexicographic on (op, a, b) [or the sat2 order (op, a, b) with op most significant — the same thing];
`Prog` order lexicographic.
Semantics: `step (w : WeakOrder n) : State → Instr → State`, `State := (Reg → Label) × Flag`, `Label := Fin n ⊕ T`;
`correctRS w (p,out) := ∀ j, label (run w p at out j) is not T ∧ rank_w (label ...) = j` (rank by blocks of w).

Rules (each is `Prog → Prop`; the theorem: `∃ correct RS program of length m` → `∃ correct RS program of length m with all rules`
holds for `m` minimal; S-rules need minimality, D-rules do not):
- `R1 p`: let `first j` = index of the first operand slot (in scan order (t, a then b)) that mentions `S j`; then `S j` occurs ⇒
  ∀ j' < j, `S j'` occurs ∧ `first j' < first j`.
- `R2 p`: ∀ t, `indep p[t] p[t+1] → p[t] < p[t+1]`.
- `R5 p`: ∀ t, `p[t].op = cmp → p[t].a < p[t].b`.
- `R6 p` (RS only): as R1 for `P i`.
- `R7 p`: ∀ t, `p[t].op ∈ {cmovl,cmovg,cmovle,cmovge} → ∃ t' < t, p[t'].op = cmp`.
- `S1 p`: ∀ t, `p[t].op ≠ cmp → p[t].a ≠ p[t].b`.
- `S2 p`: ∀ t, `p[t].op ≠ cmp →` the location `p[t].a` is read (by some `p[u]`, u > t, `reg a ∈ Rd p[u]`, or by a snapshot
  `out j = (a, v)` with t < v ≤ u; positions count executed instructions, list index 0-based) before the least u > t with
  `p[u].op = mov ∧ p[u].a = p[t].a` (u := length if none; in RF/RE the end also reads `a` if it is an output).
- `R1' p` (sat2 form, used with `R2' p`): first **writes** of scratch registers in index order; `R2'`: a scratch read before
  its first write is `S last`, and `S last` is never written. Sound by the same lex-min argument (proof in agents/sat2/RULES.md,
  reviewed). R1 and R1' are different rules: use one family per encoding.
- `S3 p`: ∀ t, `p[t].op = cmp → ∃ u > t, p[u].op ∈ cmov ∧ ∀ v ∈ (t,u), p[v].op ≠ cmp`.
- `S5 p`: ∀ t, `p[t].op = cmp → p[t].a ≠ p[t].b`.
Operations (each preserves length and `∀ w, correctRS w`): `ρ π` (scratch perm), `ι π` (input perm, RS only),
`σ t` (swap, moves snapshots as in L6.0), `φ t` (cmp flip), `μ` (pre-cmp cmovle/ge → mov).
Master lemma: `p* := argmin_lex (closure {σ,ρ,ι,φ} (μ p))` satisfies R1 R2 R5 R6 R7; if `p` is shortest, also S1 S2 S3 S5.
