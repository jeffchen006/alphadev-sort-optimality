# n=5 model=out iset=I1 prefix14_class=5104
mov S2, P2
cmp P2, P1
cmovg P2, P1
cmovl S2, P1
mov S0, P2
cmp P3, P0
cmovl S1, P0
cmovge S1, P3
cmovg P3, P0
cmp S0, P3
cmovl P2, P3
cmovl P3, S0
cmp S2, S1
cmovge P0, S1
