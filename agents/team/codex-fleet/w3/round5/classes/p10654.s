# n=5 model=out iset=I1 prefix14_class=10654
cmp P0, P1
cmovl S1, P1
mov S2, P2
cmovl P1, P0
cmovl P0, S1
mov S0, P0
cmp P3, P2
cmovg P2, P3
cmovge P3, S2
cmp S0, P2
cmovge S0, P2
cmovge P2, P0
cmp P3, P1
cmovl S1, P3
