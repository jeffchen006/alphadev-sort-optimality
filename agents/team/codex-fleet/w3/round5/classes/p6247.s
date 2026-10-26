# n=5 model=out iset=I1 prefix14_class=6247
cmp P2, P1
mov S2, P3
cmovge S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
cmovl P3, P0
cmp S2, P1
mov S1, P1
cmovge P1, S2
cmovge S2, S1
cmp P2, P0
