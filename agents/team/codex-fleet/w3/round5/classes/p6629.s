# n=5 model=out iset=I1 prefix14_class=6629
mov S0, P3
cmp P1, P2
cmovl S2, P2
cmovge S2, P1
cmovl P2, P1
cmp P3, P0
cmovg S0, P0
cmovl P3, P0
cmp S2, P3
cmovge P0, P3
cmovge P3, S2
cmovge S2, P0
cmp S0, P2
cmovg P0, S0
