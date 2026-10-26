# n=5 model=out iset=I1 prefix14_class=12844
mov S1, P0
mov S0, P1
cmp P2, S0
cmovl S0, P2
cmovge P1, P2
mov S2, S0
cmp S1, P3
cmovge P0, P3
cmovl S1, P3
cmp S0, P0
cmovge S2, P0
cmovge P0, S0
cmp P1, S1
cmovge S0, S1
