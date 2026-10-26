# n=5 model=out iset=I1 prefix14_class=1010
mov S2, P1
cmp S2, P2
cmovl S2, P2
cmovl P2, P1
cmp P3, P0
mov S0, P3
cmovge P3, P0
cmovg P0, S0
mov P1, S2
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmp P3, P2
cmovl S0, P2
