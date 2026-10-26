# n=5 model=out iset=I1 prefix14_class=1955
cmp P2, P1
cmovl S1, P2
cmovge S1, P1
mov S0, P0
cmovl P2, P1
cmp P3, S0
cmovg S0, P3
cmovl P0, P3
mov S2, P2
cmp S0, P2
cmovl S2, S0
cmovg P2, S0
mov P1, S2
cmp P0, S1
