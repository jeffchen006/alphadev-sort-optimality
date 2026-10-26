# n=5 model=out iset=I1 prefix14_class=5496
cmp P2, P3
mov S1, P2
cmovle S1, P3
mov S2, P0
cmovl P3, P2
cmp S2, P1
cmovle P0, P1
cmovge S2, P1
mov P1, P3
cmp P3, S2
cmovle P1, S2
cmovl S2, P3
cmp P0, S1
cmovle S2, P0
