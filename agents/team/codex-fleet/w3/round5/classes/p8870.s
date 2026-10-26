# n=5 model=out iset=I1 prefix14_class=8870
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovg P3, P2
mov S0, P1
cmp S2, P1
cmovge P1, S2
cmovge S2, S0
cmp P0, P3
cmovl S1, P0
