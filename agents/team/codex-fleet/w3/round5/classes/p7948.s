# n=5 model=out iset=I1 prefix14_class=7948
cmp P2, P3
mov S2, P2
cmovge S2, P3
cmovl P2, P3
cmp P0, P1
cmovge P3, P0
mov S0, S2
cmovg P0, P1
cmovge P1, P3
cmp S0, P0
cmovge S0, P0
mov S0, P2
cmovl S2, P0
cmp P2, P1
