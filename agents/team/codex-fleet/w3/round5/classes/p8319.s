# n=5 model=out iset=I1 prefix14_class=8319
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
mov S2, P0
cmovl P1, S0
cmp S2, P3
cmovg P0, P3
cmovle S2, P3
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
cmovge S1, P1
cmp S2, P2
mov P1, S2
