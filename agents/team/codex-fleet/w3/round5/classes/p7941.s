# n=5 model=out iset=I1 prefix14_class=7941
mov S2, P2
cmp P2, P0
cmovge P2, P0
cmovl S2, P0
mov P0, S2
mov S0, P1
cmp P1, P3
cmovg S0, P3
cmovg P3, P1
cmp S0, P2
cmovge P1, P2
cmovge P2, S0
cmovge S0, P1
cmp P0, P3
