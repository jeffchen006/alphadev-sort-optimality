# n=5 model=out iset=I1 prefix14_class=11340
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P2, P1
cmovge S1, P2
cmovl S1, P1
cmovg P2, P1
cmp S1, P3
cmovle P1, S1
cmovle S1, P3
cmovle P3, P1
mov S0, P2
cmp P0, P2
