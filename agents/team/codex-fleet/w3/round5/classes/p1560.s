# n=5 model=out iset=I1 prefix14_class=1560
mov S1, P2
cmp P3, S1
cmovg S1, P3
cmovge P3, P2
cmp P0, P1
mov S0, P0
cmovge P0, P1
cmovl S0, P1
mov S2, P3
cmp P3, P0
cmovge P3, P0
cmovg P0, S2
cmp S0, S1
cmovge P2, S1
