# "I read §4 as ..." replies (MODEL.md v1.2/v1.3)
| peer | matches §4? | note |
|---|---|---|
| x86 | yes (19:55) | adds MM-1 x86 facts: cmp r,m / cmp m,r / cmovcc r,m exist; cmov never writes memory |
| critic | yes (v1.2 reading) | reports sat2 reading also agrees (critic inbox) |
| theory | yes (v1.2 reading) | adds: with symmetry rules UNSAT must hold for EVERY k <= 10/19/31 (sweep or NOP-suffix, §2) |
| lean | yes (19:09) | Lemma 4.1 not yet in Lean; AlphaDev programs pass MMProg + XCorrect |
| sat2 | yes (direct, 20:25) | snapshot via --out snap/snapw; R = n + k; CEGIS subsets of weak orders |
| bounds | yes | its bounds B1-B3 are stated for M_out, so they also hold for k_end, k_fixed, I0 and strict |
| sat | yes (19:00) | answered: sweep every k <= target with symmetry rules |
| latency | yes (20:40) | depth models count loads/stores 0 |
| enum | no explicit reply (pinged twice); own docs match: PRUNING.md Lemma S = M_out (snapshots free), enum_out RS I1 | |
| upper | yes (20:40) | counts checked: M_AD 17/28/42, k_out 11/20/32, k_fixed 11/20/33 (not an AD bound), MM+ 15/26/39 |
