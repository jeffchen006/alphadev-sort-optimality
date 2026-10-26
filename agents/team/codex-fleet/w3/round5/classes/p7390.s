# n=5 model=out iset=I1 prefix14_class=7390
mov S1, P3
cmp P3, P2
cmovle P3, P2
cmovle P2, S1
mov S2, P3
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P1, P3
