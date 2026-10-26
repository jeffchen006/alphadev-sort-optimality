# n=5 model=out iset=I1 prefix14_class=2673
mov S1, P2
cmp P1, P2
cmovge P2, P1
cmovl S1, P1
cmp P3, P0
mov S2, P3
cmovl P3, P0
cmovge S2, P0
mov P0, P3
cmp P2, P0
cmovl P3, P2
cmovl P2, P0
cmp S1, S2
mov P2, P3
