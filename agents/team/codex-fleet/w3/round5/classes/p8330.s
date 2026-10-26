# n=5 model=out iset=I1 prefix14_class=8330
cmp P3, P2
cmovle S0, P3
cmovge S0, P2
cmovle P3, P2
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
cmp S0, P0
cmovge P2, P0
cmovl P2, S0
mov S2, P1
cmovl S0, P0
cmp P1, P3
