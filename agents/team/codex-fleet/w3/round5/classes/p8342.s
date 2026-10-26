# n=5 model=out iset=I1 prefix14_class=8342
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovl P2, S2
cmp P1, P3
cmovl S1, P3
cmovge S1, P1
cmovg P1, P3
cmp P1, P0
cmovl S0, P1
cmovge S0, P0
cmovle P1, P0
mov P3, S1
cmp S1, P2
