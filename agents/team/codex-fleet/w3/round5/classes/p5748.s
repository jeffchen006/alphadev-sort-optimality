# n=5 model=out iset=I1 prefix14_class=5748
mov S1, P2
cmp S1, P0
cmovl S1, P0
cmovge P2, P0
cmp P1, P3
mov P0, P1
cmovge P0, P3
cmovge P3, P1
cmovg P1, P0
cmp P2, P0
cmovl P0, P2
cmovg P1, P2
cmp P3, S1
cmovge S0, P3
