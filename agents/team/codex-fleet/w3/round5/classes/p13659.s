# n=5 model=out iset=I1 prefix14_class=13659
cmp P1, P2
cmovle S1, P2
cmovge S1, P1
cmovl P2, P1
cmp P0, P3
cmovl S0, P0
cmovle P0, P3
cmovl P3, S0
cmp S1, P0
mov P1, S1
cmovg P1, P0
cmovl S1, P0
cmp P3, P2
cmovle S1, P3
