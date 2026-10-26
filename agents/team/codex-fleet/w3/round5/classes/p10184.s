# n=5 model=out iset=I1 prefix14_class=10184
mov S2, P3
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovl S1, P1
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
mov P3, S2
cmp S1, P3
