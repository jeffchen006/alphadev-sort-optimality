# n=5 model=out iset=I1 prefix14_class=13069
mov S0, P2
cmp P2, P3
cmovge P2, P3
mov S1, P1
cmovge P3, S0
cmp S1, P0
cmovl S1, P0
cmovge P1, P0
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
mov S2, P1
cmp S1, P3
