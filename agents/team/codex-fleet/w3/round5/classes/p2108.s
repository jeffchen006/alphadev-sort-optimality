# n=5 model=out iset=I1 prefix14_class=2108
cmp P0, P3
mov S0, P3
cmovg S0, P0
cmovl P3, P0
cmp P2, P1
mov S1, P1
cmovg S1, P2
cmovg P2, P1
cmp S0, S1
mov S2, S1
cmovge S1, S0
mov S1, P2
cmovge S0, S2
cmp S1, P3
