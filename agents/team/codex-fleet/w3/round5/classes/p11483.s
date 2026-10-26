# n=5 model=out iset=I1 prefix14_class=11483
mov S1, P1
cmp P0, P3
cmovge S2, P0
cmovl S2, P3
cmovl P3, P0
cmp S1, P2
cmovge S1, P2
cmovge P2, P1
mov P1, P2
cmp S1, P3
cmovle P0, S1
cmovl S1, P3
cmovl P3, P0
cmp S2, P1
