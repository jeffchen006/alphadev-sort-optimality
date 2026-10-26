# n=5 model=out iset=I1 prefix14_class=3787
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
cmp P3, P0
mov S0, P3
mov S1, P1
cmovl S0, P0
cmovge P3, P0
mov P0, S0
cmp S1, P3
cmovl P1, P3
cmovl P3, S1
cmp P2, P0
