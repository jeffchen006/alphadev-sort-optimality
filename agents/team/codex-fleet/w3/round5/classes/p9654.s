# n=5 model=out iset=I1 prefix14_class=9654
mov S2, P1
cmp P2, P0
cmovge S0, P0
cmovl S0, P2
cmovl P2, P0
cmp S2, P3
cmovg P1, P3
cmovl S2, P3
cmp P2, S2
cmovge P0, P2
cmovge P2, S2
cmovge S2, P0
cmp S0, P1
cmovge P0, P1
