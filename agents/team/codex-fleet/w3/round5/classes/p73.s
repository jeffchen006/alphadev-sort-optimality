# n=5 model=out iset=I1 prefix14_class=73
mov S2, P1
mov S0, P3
cmp P3, P2
cmovl P3, P2
cmovge S0, P2
cmp P0, P1
cmovl S2, P0
cmovg P1, P0
cmp S2, S0
cmovge P0, S2
mov P2, P1
cmovge S2, S0
cmovg S0, P0
cmp P2, P3
