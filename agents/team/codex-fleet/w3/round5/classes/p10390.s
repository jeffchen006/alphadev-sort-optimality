# n=5 model=out iset=I1 prefix14_class=10390
cmp P1, P0
mov S2, P3
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
cmovl S2, P2
mov S0, P0
cmovge P3, P2
cmp S0, S2
cmovl S0, S2
cmovl S2, P0
cmp P3, P1
cmovge P0, P3
