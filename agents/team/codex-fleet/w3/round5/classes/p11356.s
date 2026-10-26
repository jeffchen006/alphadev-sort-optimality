# n=5 model=out iset=I1 prefix14_class=11356
mov S0, P0
cmp P2, P1
cmovge S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P3, P0
cmovg S0, P3
mov S2, P2
cmovl P0, P3
cmp S0, P1
cmovl S1, S0
cmovl S0, P1
cmovl P1, S1
cmp P0, S2
