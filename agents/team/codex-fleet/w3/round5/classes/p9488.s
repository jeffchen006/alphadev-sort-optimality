# n=5 model=out iset=I1 prefix14_class=9488
cmp P1, P0
mov S2, P0
cmovge S2, P1
cmovl P0, P1
cmp P2, P3
cmovge S1, P2
cmovg P2, P3
cmovge P3, S1
mov S0, P2
cmp P0, P2
cmovl P2, P0
cmovl P0, S0
cmp S2, P3
mov P2, P3
