# n=5 model=out iset=I1 prefix14_class=10567
mov S0, P1
cmp P3, P1
cmovg S0, P3
cmovl P1, P3
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
cmp S0, P0
cmovge S1, S0
cmovl S1, P0
cmovg S0, P0
mov S1, P2
cmp P2, P1
