# n=5 model=out iset=I1 prefix14_class=5810
mov S0, P3
cmp P2, S0
cmovge S0, P2
cmovle P3, P2
mov S2, P3
cmp P1, P0
cmovg P2, P1
cmovg P1, P0
cmovg P0, P2
cmp P1, S2
cmovge S2, P1
mov S1, S0
cmovge P1, P3
cmp P0, S1
