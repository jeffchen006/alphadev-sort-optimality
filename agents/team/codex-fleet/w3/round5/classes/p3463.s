# n=5 model=out iset=I1 prefix14_class=3463
mov S0, P2
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmp P2, P3
cmovge S0, P3
cmovl P2, P3
cmp P0, S0
mov S2, P2
cmovg P1, S0
cmovge S0, P0
cmovg P0, P1
cmp S1, P2
