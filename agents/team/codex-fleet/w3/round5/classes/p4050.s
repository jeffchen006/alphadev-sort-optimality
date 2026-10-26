# n=5 model=out iset=I1 prefix14_class=4050
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovge P3, S2
mov S0, P1
cmp P2, P1
cmovl S0, P2
cmovg P1, P2
cmp P0, S0
cmovl P2, S0
cmovge P2, P0
cmovl S0, P0
cmp P3, P1
mov S0, P2
