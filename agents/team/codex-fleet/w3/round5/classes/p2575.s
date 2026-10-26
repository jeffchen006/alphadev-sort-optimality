# n=5 model=out iset=I1 prefix14_class=2575
mov S0, P3
cmp P3, P2
mov S2, P1
cmovl P3, P2
cmovge S0, P2
cmp P0, P1
mov S1, P3
cmovg S2, P0
cmovge P0, P1
cmp S1, S2
cmovg P3, S2
cmovl S1, S2
mov S2, P0
cmp P0, S0
