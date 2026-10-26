# n=5 model=out iset=I1 prefix14_class=10840
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
cmp P0, P1
cmovge S0, P0
cmovl S0, P1
cmovg P0, P1
mov P1, P3
cmp S0, P3
mov S1, P2
cmovl P1, S0
cmovg P3, S0
cmovge S0, P1
