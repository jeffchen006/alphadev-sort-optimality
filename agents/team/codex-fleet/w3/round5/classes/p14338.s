# n=5 model=out iset=I1 prefix14_class=14338
mov S1, P0
cmp P3, P2
cmovle S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, P1
cmovl S1, P1
cmovge P0, P1
cmp S2, P0
cmovl P1, P0
cmovle P0, S2
cmovl S2, P1
mov P0, S1
cmp P3, P0
