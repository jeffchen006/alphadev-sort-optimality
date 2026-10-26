# n=5 model=out iset=I1 prefix14_class=5468
mov S2, P3
cmp P3, P2
cmovge S2, P2
cmovl P3, P2
cmp P0, P1
mov P2, P1
cmovg P1, P0
cmovg P0, P2
cmp S2, P0
mov S1, P0
cmovle S1, S2
cmovl S2, P0
cmp P3, P1
cmovle P0, P3
