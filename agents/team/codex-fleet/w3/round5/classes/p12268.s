# n=5 model=out iset=I1 prefix14_class=12268
cmp P1, P3
mov S0, P3
cmovge P3, P1
cmovl S0, P1
cmp P2, P0
cmovge S1, P0
mov P1, S0
cmovge P0, P2
cmovge P2, S1
cmp S0, P2
cmovg P1, P2
mov P1, P3
cmovg P2, S0
cmp P0, P3
