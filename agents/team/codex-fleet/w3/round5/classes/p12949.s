# n=5 model=out iset=I1 prefix14_class=12949
cmp P1, P0
cmovge S2, P1
cmovl S2, P0
cmovge P1, P0
cmp P3, P2
mov S0, P2
cmovg P2, P3
cmovge P3, S0
cmp P3, P1
cmovl S0, P3
cmovl P3, P1
cmovl P1, S0
mov P1, P2
cmp S2, P2
