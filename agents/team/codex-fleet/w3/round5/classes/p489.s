# n=5 model=out iset=I1 prefix14_class=489
cmp P3, P0
cmovle S0, P0
cmovge S0, P3
cmovle P0, P3
mov S1, P2
cmp P2, P1
cmovge S1, P1
cmovg P1, P2
cmp P0, S1
mov P2, S0
cmovl S2, S1
cmovle S1, P0
cmovl P0, S2
cmp S0, P1
