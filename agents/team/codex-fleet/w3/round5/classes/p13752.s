# n=5 model=out iset=I1 prefix14_class=13752
cmp P2, P1
mov S2, P2
cmovl S2, P1
cmovge P2, P1
cmp P0, P3
cmovl S1, P3
cmovge S1, P0
cmovg P0, P3
cmp S2, S1
cmovg S0, S2
cmovg S2, S1
cmovg S1, S0
cmp P0, P2
cmovl P3, P0
