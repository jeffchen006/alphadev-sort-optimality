# n=5 model=out iset=I1 prefix14_class=5396
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
cmovge S2, P1
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovl S1, P0
cmp S2, P3
cmovge P0, S2
mov S0, S1
cmovge S2, P3
cmovg P3, P0
cmp P2, S0
