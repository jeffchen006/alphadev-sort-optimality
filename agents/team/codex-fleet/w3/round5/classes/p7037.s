# n=5 model=out iset=I1 prefix14_class=7037
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
mov S1, P3
cmovg P2, S2
cmp S1, P1
cmovg P3, P1
cmovl S1, P1
cmp P3, P2
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P0, S1
cmovg P2, P0
