# n=5 model=out iset=I1 prefix14_class=2257
mov S2, P3
cmp S2, P0
cmovl S2, P0
cmovge P3, P0
cmp P1, P2
cmovg P0, P1
cmovge P1, P2
cmovg P2, P0
cmp P2, S2
cmovl P0, P2
cmovl P2, S2
cmovl S2, P0
mov P2, P1
cmp P1, P3
