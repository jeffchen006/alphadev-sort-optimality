# n=5 model=out iset=I1 prefix14_class=14260
cmp P0, P2
cmovge S2, P2
mov S0, P3
cmovge P2, P0
cmovge P0, S2
cmp P1, S0
cmovge S0, P1
cmovge P1, P3
cmp S0, P2
mov S1, S0
cmovl S1, P2
cmovg S0, P2
cmp P1, P0
cmovg S2, P1
