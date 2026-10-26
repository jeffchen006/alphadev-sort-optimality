# n=5 model=out iset=I1 prefix14_class=3920
cmp P2, P1
cmovge S0, P2
mov S1, P3
cmovg P2, P1
cmovg P1, S0
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovge P3, P0
cmp P2, P0
cmovge P3, P2
cmovg P2, P0
mov P2, P1
cmp S1, P1
