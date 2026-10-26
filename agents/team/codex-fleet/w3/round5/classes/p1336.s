# n=5 model=out iset=I1 prefix14_class=1336
cmp P0, P1
cmovge S1, P0
cmovl S1, P1
cmovl P1, P0
cmp P3, P2
mov S2, P3
cmovg S2, P2
mov P0, S1
cmovg P2, P3
cmp P2, P0
cmovle P0, P2
cmovge S1, P2
mov S1, P1
cmp S2, P1
