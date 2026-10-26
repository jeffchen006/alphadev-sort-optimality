# n=5 model=out iset=I1 prefix14_class=7150
mov S0, P1
cmp P2, S0
cmovl S0, P2
cmovg P1, P2
mov P2, P3
cmp P3, P0
mov S2, S0
cmovl P3, P0
cmovl P0, P2
cmp S2, P0
cmovl S0, P0
cmovg S2, P0
cmp P1, P3
cmovge S1, P1
