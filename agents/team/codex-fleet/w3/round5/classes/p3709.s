# n=5 model=out iset=I1 prefix14_class=3709
mov S2, P3
cmp S2, P1
cmovl P3, P1
cmovge S2, P1
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
mov P1, P2
cmp S2, P1
cmovge P1, S2
cmovl P2, S2
cmovl S2, P1
cmp P3, P0
