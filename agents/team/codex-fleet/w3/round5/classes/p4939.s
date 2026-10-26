# n=5 model=out iset=I1 prefix14_class=4939
mov S0, P1
cmp S0, P2
cmovl P1, P2
cmovge S0, P2
mov S2, S0
cmp P0, P3
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P3
cmovg S2, P3
cmovg P3, S0
cmp P0, P1
cmovge S1, P0
