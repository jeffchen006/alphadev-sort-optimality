# n=5 model=out iset=I1 prefix14_class=6597
mov S2, P0
mov S0, P2
cmp P1, S2
cmovge S2, P1
cmovl P0, P1
cmp P2, P3
cmovl S0, P3
cmovl P3, P2
mov S1, S0
cmp S2, S0
cmovg S0, S2
cmovge S2, S1
cmp P0, P3
cmovg S1, P3
