# n=5 model=out iset=I1 prefix14_class=2263
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovl S0, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
cmovge P0, P2
mov P2, P0
cmp P0, S0
cmovl P0, S0
mov P0, P1
cmovl S0, P2
cmp P1, P3
