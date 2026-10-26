# n=5 model=out iset=I1 prefix14_class=11165
mov S2, P2
mov S0, P1
cmp P2, P0
cmovl S2, P0
cmovg P2, P0
cmp S0, P3
cmovl P1, P3
cmovg S0, P3
cmp S2, P1
mov S1, S2
cmovg S1, P1
cmovl S2, P1
cmp P2, S0
cmovge S2, S0
