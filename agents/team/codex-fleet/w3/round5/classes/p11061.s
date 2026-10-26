# n=5 model=out iset=I1 prefix14_class=11061
mov S2, P2
cmp S2, P3
cmovg S2, P3
cmovg P3, P2
cmp P0, P1
cmovl P2, P1
cmovl P1, P0
cmovl P0, P2
mov S0, P0
cmp P3, S0
mov S1, P1
cmovl P0, P3
cmovge S0, P3
cmp S2, S1
