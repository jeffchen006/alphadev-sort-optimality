# n=5 model=out iset=I1 prefix14_class=7872
cmp P2, P3
mov S1, P1
cmovl S2, P3
cmovge S2, P2
cmovl P3, P2
cmp P1, P0
cmovl S1, P0
cmovge P1, P0
cmp P1, P3
cmovge S0, P1
cmovge P1, P3
mov P1, S2
cmovg P3, S0
cmp S1, P1
