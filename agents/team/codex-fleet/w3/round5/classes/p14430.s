# n=5 model=out iset=I1 prefix14_class=14430
cmp P2, P3
mov S1, P0
cmovl S2, P2
cmovle P2, P3
cmovge S2, P3
cmp P1, S1
cmovge S1, P1
cmovl P0, P1
cmp S2, P0
cmovge S0, S2
cmovg S2, P0
cmovg P0, S0
cmp P2, S1
cmovle S2, P2
