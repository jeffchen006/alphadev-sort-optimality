# n=5 model=out iset=I1 prefix14_class=1643
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
mov S0, P1
cmovl S1, P0
cmp P3, P1
cmovl P1, P3
cmovg S0, P3
mov S2, P1
cmp S2, P2
cmovl P1, P2
cmovg S2, P2
mov S2, S0
cmp S0, S1
