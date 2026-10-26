# n=5 model=out iset=I1 prefix14_class=7251
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P0, P3
cmovle P2, P3
cmovl P3, P0
mov S2, P3
cmovl P0, P2
cmp P3, P1
cmovle S2, P1
cmovg P3, P1
cmp S1, P0
mov P3, S1
