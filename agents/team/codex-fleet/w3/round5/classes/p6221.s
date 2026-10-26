# n=5 model=out iset=I1 prefix14_class=6221
cmp P0, P3
cmovge S1, P3
cmovle S1, P0
cmovl P0, P3
cmp P2, P1
mov S2, P1
cmovle P1, P2
mov P3, P0
cmovg S2, P2
cmp P3, S2
cmovg P3, S2
cmovl P0, S2
cmp S1, P1
cmovl S0, P1
