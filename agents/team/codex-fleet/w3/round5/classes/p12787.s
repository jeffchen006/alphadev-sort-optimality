# n=5 model=out iset=I1 prefix14_class=12787
cmp P0, P2
cmovl S1, P2
mov S2, P1
cmovl P2, P0
cmovl P0, S1
cmp P3, P1
cmovl S2, P3
cmovg P1, P3
cmp P2, S2
cmovge S0, P2
mov S1, P1
cmovg P2, S2
cmovg S2, S0
cmp S1, P0
