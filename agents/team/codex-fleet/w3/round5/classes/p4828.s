# n=5 model=out iset=I1 prefix14_class=4828
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovge S0, P0
mov S2, P2
mov S1, P3
cmp S1, P1
cmovg P3, P1
cmovge P1, S1
cmp P3, P2
cmovl P2, P3
cmovge S2, P3
cmp S0, P1
cmovg P0, S0
