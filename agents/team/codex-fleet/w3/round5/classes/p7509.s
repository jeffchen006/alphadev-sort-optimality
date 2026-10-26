# n=5 model=out iset=I1 prefix14_class=7509
cmp P2, P0
cmovge S2, P2
cmovl S2, P0
cmovl P0, P2
cmp P1, P3
mov P2, P3
cmovge P2, P1
cmovg P1, P3
cmp P0, P1
mov P3, P0
cmovl P3, P1
cmovl P1, P0
mov P1, S2
cmp S2, P2
