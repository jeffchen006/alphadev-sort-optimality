# n=5 model=out iset=I1 prefix14_class=3448
mov S1, P2
mov S0, P3
cmp P1, S0
cmovge S0, P1
cmovg P1, P3
cmp S1, P0
cmovge P2, P0
cmovl S1, P0
cmp P2, P1
mov P0, S1
cmovg P3, P1
cmovge P1, P2
cmovg P2, P3
cmp S0, P0
