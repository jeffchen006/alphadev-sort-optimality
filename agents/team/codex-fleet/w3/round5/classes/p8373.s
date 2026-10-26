# n=5 model=out iset=I1 prefix14_class=8373
cmp P3, P2
mov S1, P1
mov S2, P3
cmovl P3, P2
cmovle P2, S2
cmp S1, P0
cmovge S1, P0
cmovge P0, P1
cmp P3, P0
cmovl S2, P3
cmovl P3, P0
cmovl P0, S2
cmp P2, S1
cmovle S2, P2
