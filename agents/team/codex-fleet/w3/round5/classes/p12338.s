# n=5 model=out iset=I1 prefix14_class=12338
mov S2, P2
mov S1, P1
cmp S2, P3
cmovl P2, P3
cmovge S2, P3
cmp P0, P1
cmovg S1, P0
cmovge P0, P1
cmp P0, S2
cmovl P3, S2
cmovl S2, P0
cmovl P0, P3
cmp P2, S1
cmovge S0, P2
