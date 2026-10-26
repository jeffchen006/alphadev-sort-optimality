# n=5 model=out iset=I1 prefix14_class=4087
mov S1, P0
cmp P2, S1
mov S2, P3
cmovl P0, P2
mov S0, P0
cmovge S1, P2
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmp S0, P1
cmovl S0, P1
cmovg P0, P1
mov P1, S2
cmp S2, S1
