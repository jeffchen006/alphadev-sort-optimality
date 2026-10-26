# n=5 model=out iset=I1 prefix14_class=12270
cmp P2, P0
mov S0, P0
cmovge P0, P2
cmovl S0, P2
cmp P1, P3
cmovge S1, P3
mov P2, S0
cmovge P3, P1
cmovge P1, S1
cmp S0, P1
cmovg P2, P1
mov P2, P0
cmovg P1, S0
cmp P3, P0
