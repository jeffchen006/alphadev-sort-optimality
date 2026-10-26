# n=5 model=out iset=I1 prefix14_class=12996
mov S2, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, S2
cmp P2, P0
mov S0, P0
mov S1, P1
cmovl S0, P2
cmovl P2, P0
cmp P3, S0
cmovg S2, S0
cmovge S0, P3
cmovg P3, S2
cmp S1, P2
