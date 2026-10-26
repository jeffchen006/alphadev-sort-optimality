# n=5 model=out iset=I1 prefix14_class=7236
mov S0, P2
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
cmovl S1, P0
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp S0, S1
