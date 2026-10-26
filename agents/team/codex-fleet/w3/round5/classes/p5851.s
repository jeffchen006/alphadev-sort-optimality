# n=5 model=out iset=I1 prefix14_class=5851
cmp P0, P2
mov S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovge S1, P1
cmp S1, S2
cmovl P1, S1
cmovl S1, S2
cmovl S2, P1
mov P2, P0
cmp P0, P3
