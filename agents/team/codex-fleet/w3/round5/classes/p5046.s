# n=5 model=out iset=I1 prefix14_class=5046
mov S2, P3
cmp P1, S2
cmovge P3, P1
cmovl S2, P1
cmp P2, P0
mov S0, P0
cmovge P0, P2
cmovl S0, P2
cmp S0, S2
mov P1, S2
cmovge S2, S0
cmovl P1, S0
cmp P3, P0
cmovl S1, P0
