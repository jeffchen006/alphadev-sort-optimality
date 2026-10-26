# n=5 model=out iset=I1 prefix14_class=9352
mov S2, P3
cmp P1, P3
cmovl S2, P1
mov S1, P2
cmovl P1, P3
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmp S1, S2
cmovge P2, S2
cmovge S2, S1
cmovge S1, P2
cmp P1, P0
cmovl P3, P0
