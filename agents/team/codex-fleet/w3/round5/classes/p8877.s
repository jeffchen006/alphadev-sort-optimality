# n=5 model=out iset=I1 prefix14_class=8877
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
cmp P2, P0
mov S2, P2
cmovge S2, P0
cmovle P2, P0
cmovge P0, P2
cmp P3, P2
cmovg P0, P3
cmovg P3, P2
cmp P1, S2
cmovle P2, P1
