# n=5 model=out iset=I1 prefix14_class=1378
cmp P2, P3
mov S0, P1
cmovge S2, P3
cmovg P3, P2
cmovl S2, P2
cmp P1, P0
cmovge S0, P0
mov S1, P3
cmovge P0, P1
cmp P0, S1
cmovge S1, P0
cmovl P3, P0
mov S1, S0
cmp S1, S2
