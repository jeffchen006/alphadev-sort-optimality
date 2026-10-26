# n=5 model=out iset=I1 prefix14_class=12016
cmp P3, P0
cmovge S1, P3
mov S0, P1
cmovge P3, P0
cmovge P0, S1
cmp P1, P2
cmovl S0, P2
cmovg P1, P2
cmp P1, P3
mov P2, P1
cmovl P1, P3
cmovl P3, P2
cmovl P2, P1
cmp S0, P0
