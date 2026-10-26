# n=5 model=out iset=I1 prefix14_class=12859
mov S2, P3
cmp P3, P2
cmovl P3, P2
cmovge S2, P2
cmp P1, P0
cmovle P2, P1
cmovl P1, P0
cmovg P2, P0
cmp S2, P2
cmovle S0, S2
cmovl S2, P2
cmovl P2, S0
cmp P1, P3
mov P0, P1
