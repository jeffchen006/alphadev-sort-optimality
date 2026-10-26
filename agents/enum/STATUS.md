# enum — STATUS (2026-10-24, evening)

## Tools
- `src/enum_out.cpp` -> `bin/enum_out`: set-model layered BFS for M_out (MODEL §4.3), R unbounded, relaxed §2.
  `enum_out N WEAK ISET KBOUND THREADS SYM [OUT.s]`; env: `NG=1` (rule NG v3, claim = strict-correct programs),
  `NOREC=1` (no program recovery, less memory), `CMAX=c` (max columns per state; exceeding it aborts with exit 6),
  `CHUNK=n`, `TRACE=prog.s` (admissibility test along a program), `HCHECK=1` (incremental h == full h test).
  Build: `g++ -O3 -march=native -fopenmp -o bin/enum_out src/enum_out.cpp`.
- `src/count.cpp` -> `bin/count`: exact count of length-K programs in the register model (outputs = final P_j).
- `src/check.py`: own program checker (relaxed + strict with garbage + 4 initial flag states).
- `src/enum_reg.cpp`: first register-model tool (not used for claims).
- Rules + proofs: `PRUNING.md` v3. theory review: v1 sound, v2 H3' sound / NG gap, v3 NG sound (proof-text fix applied).

## Results
- n=3, M_out, I1 and I0, all 13 weak orders: none <= 10, min 11 (relaxed, and strict via NG). Witness passes judge.
- n=4, M_out, I1, 24 perms, NG: none <= 17 (2.6M), <= 18 (55.8M), **<= 19 (1.39e9 states, 5756 s)** => k_out(4) = 20.
- TRACE: h admissible on every prefix of 15 AlphaDev out programs + 4 team programs.
- Counts (n=3, k=11, register model, R=4, I0, perms, cmp i<j only): 5602 = Ullrich-Hack's number (independent repro).

## Running
- k<=18 certificate export -> certs/sort4_I1_k18_ng1.cert (logs/cert_k18.log). Certs: certs/*.cert (format v1).

## Next
- CMPMAX / exact-c + bounds' Huffman/MCUT terms; sort5 split cases.
- n=5: h(root)=15 vs 32; growth ~18x per unit of slack: infeasible without stronger bounds.
