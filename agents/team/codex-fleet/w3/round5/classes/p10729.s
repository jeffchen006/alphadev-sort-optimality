# n=5 model=out iset=I1 prefix14_class=10729
mov S0, P2
cmp P0, S0
cmovge S0, P0
cmovg P0, P2
mov S1, P1
cmp S1, P3
cmovl S1, P3
cmovl P3, P1
mov S2, P3
cmp S1, S0
cmovg P1, S0
cmovge S0, S1
cmovg S1, P1
cmp S2, P0
