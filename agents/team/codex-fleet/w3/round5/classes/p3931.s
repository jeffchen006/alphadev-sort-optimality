# n=5 model=out iset=I1 prefix14_class=3931
mov S2, P3
cmp P0, P3
cmovg P3, P0
cmovl S2, P0
cmp P1, P2
mov S1, S2
mov P0, P2
cmovl P0, P1
cmovge P2, P1
cmp S1, P0
cmovl S2, P0
cmovl P0, S1
mov P0, P2
cmp P2, P3
