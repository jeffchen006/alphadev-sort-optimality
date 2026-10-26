# n=5 model=out iset=I1 prefix14_class=5560
mov S2, P1
cmp P1, P2
cmovg P1, P2
cmovl S2, P2
cmp P0, P3
cmovle P2, P0
cmovl P0, P3
cmovl P3, P2
cmp P1, P3
cmovle S0, P3
cmovge S0, P1
cmovl P3, P1
mov P3, S0
cmp S2, P0
