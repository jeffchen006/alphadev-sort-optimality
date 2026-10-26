# n=5 model=out iset=I1 prefix14_class=2106
cmp P0, P1
mov S0, P1
cmovg S0, P0
cmovl P1, P0
cmp P2, P3
mov S2, P3
cmovg S2, P2
cmovg P2, P3
cmp S0, S2
cmovge S1, S2
cmovge S2, S0
mov S2, P2
cmovge S0, S1
cmp S2, P1
