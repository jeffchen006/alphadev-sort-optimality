# n=5 model=out iset=I1 prefix14_class=8653
mov S2, P2
cmp S2, P1
mov S0, P0
cmovl P2, P1
cmovge S2, P1
cmp P3, P0
cmovl S0, P3
mov S1, P2
cmovl P3, P0
cmp P2, P3
cmovg P2, P3
cmovge P3, S1
cmp S2, S0
cmovg P0, S0
