# n=5 model=out iset=I1 prefix14_class=5364
cmp P2, P3
mov S0, P2
cmovge P2, P3
cmovl S0, P3
cmp P1, P0
cmovge S1, P0
cmovl S1, P1
cmovg P0, P1
cmp P2, S1
mov P1, S1
cmovge S1, P2
cmovl P1, P2
cmp S0, P0
cmovg P2, S0
