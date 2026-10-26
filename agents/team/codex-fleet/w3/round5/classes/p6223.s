# n=5 model=out iset=I1 prefix14_class=6223
cmp P0, P2
cmovl S0, P0
cmovge S0, P2
cmovl P0, P2
cmp P3, P1
mov P2, P1
cmovge P2, P3
cmovge P3, P1
cmp P2, P0
mov P1, P0
cmovge P1, P2
cmovl P0, P2
cmovge P2, P0
cmp S0, P3
