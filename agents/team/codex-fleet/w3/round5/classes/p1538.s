# n=5 model=out iset=I1 prefix14_class=1538
cmp P3, P2
mov S0, P2
cmovl S0, P3
cmovge P2, P3
cmp P0, P1
mov S1, P0
cmovge S1, P1
cmovg P1, P0
cmp S0, S1
cmovge P3, S0
cmovge S0, S1
mov S2, P1
cmovg S1, P3
cmp P2, P1
