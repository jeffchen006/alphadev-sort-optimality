# n=5 model=out iset=I1 prefix14_class=6955
mov S1, P3
cmp P1, P0
cmovge S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, S1
cmovle P3, P2
cmovge S1, P2
cmp P0, S1
cmovg S0, P0
cmovge P0, S1
cmovg S1, S0
cmp P3, P1
cmovle P2, P1
