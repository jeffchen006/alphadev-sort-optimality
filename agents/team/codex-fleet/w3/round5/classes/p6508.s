# n=5 model=out iset=I1 prefix14_class=6508
mov S2, P2
cmp P1, S2
mov S1, P3
cmovle P2, P1
cmovge S2, P1
cmp P0, P3
cmovl P3, P0
cmovl P0, S1
mov P1, P0
cmp S2, P0
cmovl P1, S2
cmovle S2, P0
cmp P3, P2
cmovl S1, P2
