# n=5 model=out iset=I1 prefix14_class=5470
mov S2, P1
cmp P1, P2
cmovge S2, P2
cmovl P1, P2
cmp P0, P3
cmovge S1, P3
cmovg P3, P0
cmovg P0, S1
cmp S2, P0
mov P2, P0
cmovle P2, S2
cmovl S2, P0
cmp P1, P3
cmovle S1, P1
