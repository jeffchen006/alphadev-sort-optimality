# n=5 model=out iset=I1 prefix14_class=1808
mov S1, P3
cmp P0, S1
cmovge P3, P0
mov S0, P1
cmovge P0, S1
cmp P2, P1
cmovge P1, P2
cmovg P2, S0
cmp P3, P1
mov S1, P3
cmovle P3, P1
cmovg S1, P1
cmp P2, P0
cmovg S2, P0
