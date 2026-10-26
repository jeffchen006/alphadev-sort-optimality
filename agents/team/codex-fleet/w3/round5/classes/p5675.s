# n=5 model=out iset=I1 prefix14_class=5675
mov S1, P2
cmp S1, P1
cmovge S1, P1
cmovg P1, P2
mov S2, S1
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovl S0, P0
cmp S0, S1
cmovl S1, S0
cmovl S0, S2
cmp P1, P3
cmovg S2, P3
