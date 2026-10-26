# n=5 model=out iset=I1 prefix14_class=7709
cmp P2, P3
mov S1, P1
cmovle S2, P2
cmovge S2, P3
cmovle P2, P3
cmp P0, S1
cmovge S1, P0
cmovg P0, P1
cmp S2, P0
cmovle S0, P0
cmovl P0, S2
cmovl S2, S0
cmp P2, S1
mov P1, P2
