# n=5 model=out iset=I1 prefix14_class=3449
mov S1, P2
mov S0, P3
cmp P1, S0
cmovge S0, P1
cmovge P1, P3
cmp S1, P0
cmovl S1, P0
cmovg P2, P0
mov P3, S1
cmp P2, P1
cmovge P0, P1
cmovge P1, P2
cmovg P2, P0
cmp S0, P3
