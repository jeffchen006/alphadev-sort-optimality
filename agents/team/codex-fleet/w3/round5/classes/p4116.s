# n=5 model=out iset=I1 prefix14_class=4116
mov S1, P2
mov S2, P1
cmp P3, S1
cmovg S1, P3
cmovl P2, P3
cmp P0, P1
cmovg P1, P0
cmovl S2, P0
cmp S2, P2
cmovge S0, P2
cmovge P2, S2
cmovge S2, S0
cmp S1, P1
mov P3, P2
