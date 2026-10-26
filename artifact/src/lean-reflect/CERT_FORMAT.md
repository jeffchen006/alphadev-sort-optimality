# Certificate format v1 (coq 20:41 proposal + lean-reflect 3 additions; agreed coq 21:02)

Plain text (gzip allowed), one record per line, fields separated by one space.

```
cert n=<n> W=<m> iset=<I0|I1> K=<K> model=out-set ng=<0|1> rules=<comma separated list>
W <w_0> <w_1> ... <w_{m-1}>
C <count>
<id> <col>
...
S <count>
<g> <flags> <done> <gamma> <id> <id> ...
...
END <states> <sha256>
```
- `w_t` = n digits; digit i = value (dense rank 0..n-1) of input i in test t. The tests are the m = n! permutations
  (any order; checkers map this order to their own). All other lines use this test order.
- `<col>` = m digits, digit t = value of the register in test t (0..n-1, n = T). `id` = 0..count-1 in file order.
  Column lines contain no all-T column.
- `<flags>` = m digits, 0 = eq, 1 = lt, 2 = gt (any global polarity; checkers canonicalize).
- `<done>` = decimal bitmask, bit j set = output j already taken.
- `<gamma>` = number of garbage registers holding T (NG only); 0 when ng=0.
- col ids = the set of non-T columns (any order). A state line may be repeated in other symmetric forms; checkers
  canonicalize every state and keep the least g per canonical key.
- `END <states> <sha256>`: states = number of S lines; sha256 = hex digest of all bytes before the END line.
- Root (input columns, flags all eq, done 0) must be covered with g = 0. Checkers recompute every successor and
  every pruning rule themselves; the file carries no rule tags.
