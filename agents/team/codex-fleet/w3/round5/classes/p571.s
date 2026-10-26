# n=5 model=out iset=I1 prefix14_class=571
cmp P1, P2
mov S0, P1
mov S1, P3
cmovge S0, P2
cmovg P2, P1
cmp P3, P0
cmovge P3, P0
cmovl S1, P0
mov P1, P3
cmp S0, P1
cmovl P3, S0
cmovge P1, S0
mov S2, P2
cmp S1, S2
