# n=5 model=out iset=I1 prefix14_class=12511
mov S0, P2
cmp P2, P3
cmovl S0, P3
cmovl P3, P2
mov S2, P1
cmp P0, S2
cmovl S2, P0
cmovge P1, P0
cmp P3, S2
cmovl P2, P3
mov S1, P1
cmovl P3, S2
cmovl S2, P2
cmp S1, S0
