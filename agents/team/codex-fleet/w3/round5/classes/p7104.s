# n=5 model=out iset=I1 prefix14_class=7104
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
cmp P0, P2
mov S1, P0
cmovl S1, P2
cmovl P2, P0
cmp P1, P2
cmovge S0, P1
cmovle S0, P2
cmovg P1, P2
cmp S1, P3
mov P2, P3
