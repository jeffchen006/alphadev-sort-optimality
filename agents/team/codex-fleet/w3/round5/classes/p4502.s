# n=5 model=out iset=I1 prefix14_class=4502
cmp P1, P2
mov S1, P2
cmovg S1, P1
mov S0, P3
cmovg P1, P2
cmp S0, P0
cmovl S0, P0
cmovge P3, P0
cmovg P0, S0
cmp S0, S1
cmovge P0, S1
cmovg S1, S0
cmp P3, P1
cmovl S2, P1
