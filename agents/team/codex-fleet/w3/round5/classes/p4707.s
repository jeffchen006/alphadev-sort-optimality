# n=5 model=out iset=I1 prefix14_class=4707
cmp P3, P2
mov S2, P1
cmovge S0, P2
cmovl S0, P3
cmovl P3, P2
cmp S2, P0
cmovl S2, P0
mov S1, P3
cmovge P1, P0
cmp S2, P3
cmovge S1, S2
cmovg S2, P3
cmp P1, S0
cmovg P2, P1
