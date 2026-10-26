# n=5 model=out iset=I1 prefix14_class=2674
mov S1, P2
cmp P0, P2
cmovl S1, P0
cmovge P2, P0
mov S2, P3
cmp P3, P1
cmovl P3, P1
cmovge S2, P1
mov P1, P3
cmp P2, P1
cmovl P3, P2
cmovl P2, P1
mov P2, P3
cmp S1, S2
