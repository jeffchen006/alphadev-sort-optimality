# n=5 model=out iset=I1 prefix14_class=8836
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovl S0, P1
mov S2, P0
cmp P2, P0
cmovg P0, P2
cmovl S2, P2
mov S1, P0
cmp S1, S0
cmovge S1, S0
cmovg S0, P0
cmp P3, S2
cmovge P1, P3
