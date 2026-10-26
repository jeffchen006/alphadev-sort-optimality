# n=5 model=out iset=I1 prefix14_class=12363
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
mov S0, P3
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovl S1, P0
cmp P3, P1
cmovl P3, P1
cmovl P1, S0
mov P1, S1
cmp S1, P2
