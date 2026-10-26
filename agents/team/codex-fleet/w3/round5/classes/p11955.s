# n=5 model=out iset=I1 prefix14_class=11955
cmp P3, P1
cmovge S0, P1
cmovl S0, P3
cmovg P1, P3
mov S1, P0
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmp S1, P1
cmovg P3, S1
cmovge S1, P1
mov S2, P2
cmovg P1, P3
cmp S2, S0
