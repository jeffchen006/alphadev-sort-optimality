# n=5 model=out iset=I1 prefix14_class=12283
mov S2, P2
cmp P0, P2
cmovl S2, P0
cmovge P2, P0
cmp P1, P3
cmovge P0, P3
cmovge P3, P1
mov S0, S2
cmovge P1, P0
cmp S0, P1
cmovge S0, P1
cmovge P1, S2
cmp P3, P2
cmovge S0, P2
