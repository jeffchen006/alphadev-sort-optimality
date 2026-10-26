# n=5 model=out iset=I1 prefix14_class=2274
mov S1, P3
cmp P2, P1
cmovl S2, P2
cmovge S2, P1
cmovl P2, P1
cmp S1, P0
cmovge S1, P0
cmovl P3, P0
cmp P2, P3
cmovl P0, P3
cmovge P0, P2
cmovle P3, P2
mov P2, S2
cmp S1, S2
