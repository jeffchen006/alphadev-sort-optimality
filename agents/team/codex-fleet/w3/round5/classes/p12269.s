# n=5 model=out iset=I1 prefix14_class=12269
cmp P2, P3
mov S0, P3
cmovge P3, P2
cmovl S0, P2
cmp P1, P0
cmovge S1, P0
mov P2, S0
cmovge P0, P1
cmovg P1, S1
cmp S0, P1
cmovg P2, P1
mov P2, P3
cmovg P1, S0
cmp P0, P3
