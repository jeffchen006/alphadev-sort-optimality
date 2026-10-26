# n=5 model=out iset=I1 prefix14_class=9443
mov S1, P0
mov S2, P2
cmp S1, P3
cmovge S1, P3
cmovl P0, P3
cmp P2, P1
cmovl P2, P1
cmovg S2, P1
cmp S2, S1
cmovl P3, S1
cmovl S1, S2
mov S1, P0
cmovl S2, P3
cmp P2, S1
