# n=5 model=out iset=I1 prefix14_class=2504
mov S1, P0
cmp P2, P0
cmovl P0, P2
cmovl P2, S1
mov S2, P3
cmp P1, P3
mov S0, P2
cmovg S2, P1
cmovge P1, P3
cmp S0, S2
cmovl S0, S2
cmovl S2, P2
cmp P1, P0
cmovge S0, P1
