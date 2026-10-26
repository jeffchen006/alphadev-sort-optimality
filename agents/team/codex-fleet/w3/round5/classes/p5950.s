# n=5 model=out iset=I1 prefix14_class=5950
cmp P2, P3
cmovge S0, P3
mov S1, P0
cmovl S0, P2
cmovg P3, P2
cmp S1, P1
mov S2, P3
cmovl P0, P1
cmovg S1, P1
cmp P3, P0
cmovge S2, P0
cmovl P3, P0
mov P3, S1
cmp S0, S1
