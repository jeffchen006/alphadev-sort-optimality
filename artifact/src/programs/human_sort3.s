# n=3 R=7 iset=I0 model=mem source=reconstructed human baseline: optimal sorting network [(1, 2), (0, 2), (0, 1)], comparator = mov t,a; cmp a,b; cmovg a,b; cmovg b,t
# L = 2n + 4*3 = 18 (matches Nature Table 1a human benchmark)
mov S0, P0
mov S1, P1
mov S2, P2
mov S3, S1
cmp S1, S2
cmovg S1, S2
cmovg S2, S3
mov S3, S0
cmp S0, S2
cmovg S0, S2
cmovg S2, S3
mov S3, S0
cmp S0, S1
cmovg S0, S1
cmovg S1, S3
mov P0, S0
mov P1, S1
mov P2, S2
