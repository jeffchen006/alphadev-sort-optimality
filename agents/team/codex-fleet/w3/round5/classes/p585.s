# n=5 model=out iset=I1 prefix14_class=585
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
mov S0, P0
cmovge S1, P3
cmovg P3, P1
cmp S0, P2
cmovge S0, P2
cmovge P2, P0
cmp P2, P1
cmovge P3, P2
mov S2, S1
cmovl P1, P2
cmp S0, S1
