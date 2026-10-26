# n=5 model=out iset=I1 prefix14_class=10236
cmp P3, P1
mov S2, P2
cmovge S0, P1
cmovg P1, P3
cmovl S0, P3
cmp P0, S2
cmovge P2, P0
cmovg P0, S2
cmp P1, P2
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
cmp S0, P0
mov S1, S0
