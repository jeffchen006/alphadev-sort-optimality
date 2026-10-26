# n=5 model=out iset=I1 prefix14_class=8841
cmp P2, P3
cmovg S0, P2
mov S1, P0
cmovg P2, P3
cmovg P3, S0
cmp P1, P0
cmovge P0, P1
cmovl S1, P1
mov S2, P0
cmp P3, S2
cmovge P0, P3
mov P1, S1
cmovl S2, P3
cmp S1, P2
