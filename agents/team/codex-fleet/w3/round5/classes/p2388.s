# n=5 model=out iset=I1 prefix14_class=2388
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
mov S1, P0
mov S2, P2
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmp S1, S2
cmovle P0, S2
cmovl S2, S1
cmp P1, P3
cmovl S0, P1
