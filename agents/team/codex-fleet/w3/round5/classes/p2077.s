# n=5 model=out iset=I1 prefix14_class=2077
cmp P0, P3
cmovl S0, P0
cmovge S0, P3
cmovge P3, P0
mov P0, P1
cmp P0, P2
cmovge P1, P2
cmovge P2, P0
mov P0, P2
cmp P0, P3
cmovl P0, P3
cmovg P2, P3
mov P3, P1
cmp S0, P3
