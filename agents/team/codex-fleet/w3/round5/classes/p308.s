# n=5 model=out iset=I1 prefix14_class=308
cmp P1, P0
mov S0, P3
cmovge S1, P1
cmovge P1, P0
cmovge P0, S1
cmp P2, P3
cmovg S0, P2
mov S2, S0
cmovge P2, P3
cmovle P3, P2
cmp P1, P2
cmovle P3, P1
cmovle P1, P2
cmp P0, S2
