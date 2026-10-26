# n=5 model=out iset=I1 prefix14_class=6951
cmp P1, P0
mov S1, P1
cmovge P1, P0
cmovg P0, S1
mov S2, P3
cmp P2, S2
cmovle P3, P2
cmovge S2, P2
cmp P0, S2
cmovg S1, P0
cmovg P0, S2
cmovg S2, S1
cmp P3, P1
cmovge S0, P3
