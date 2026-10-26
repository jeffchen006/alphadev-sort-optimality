# d5-extend templates: sort4-core cmp columns FIXED at their slots, '*' = free lattice extension cmp; dagx_bin2 K=31
Source: 472,713 k=32 optima (rev3 folds L4=20/21) -> 360 unique templates up to S5 x reversal (tplu.txt, rank = line).
Generator genext.cpp: gensk rules (operand = lattice column index-consistent at its block, free cmp refines a class,
class bound 3^(remaining), final classes singletons on 120 perms); cap on new non-input operand columns = max(8, 2 x #free)
= no restriction (each free cmp has 2 operands). Exception: t1 first 1,831 skeletons with cap 6, + 497 extra (cap 8).
Scope of a NONE: dagx exact routing over 120 permutations (relaxed; search, not proof), lattice operands only.
| id | covers optima | free slots | #skel | result |
|---|---|---|---|---|
| t1 = u1 | 247,570 | 4 (CCC**C*C*) | 2,328 | NONE all 2,328 (0 timeout) |
| u2..u30 | | | | queued (driver.sh, log driver.log) |
