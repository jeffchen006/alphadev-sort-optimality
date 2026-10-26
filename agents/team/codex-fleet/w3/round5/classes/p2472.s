# n=5 model=out iset=I1 prefix14_class=2472
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovl S1, P3
cmp P2, P0
cmovge S0, P0
mov P3, S1
cmovg P0, P2
cmovge P2, S0
cmp S1, P0
cmovl P3, P0
cmovl P0, S1
mov S2, P1
cmp P2, S2
