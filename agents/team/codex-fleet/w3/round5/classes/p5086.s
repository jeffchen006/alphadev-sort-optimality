# n=5 model=out iset=I1 prefix14_class=5086
cmp P1, P3
mov S1, P1
cmovl P1, P3
cmovge S1, P3
mov P3, P1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovge P0, S0
cmp S1, P0
mov S2, P0
cmovl P0, S1
cmovge S2, S1
cmp P2, P1
