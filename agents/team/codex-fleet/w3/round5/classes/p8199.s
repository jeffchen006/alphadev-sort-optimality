# n=5 model=out iset=I1 prefix14_class=8199
mov S1, P0
cmp P3, P1
mov S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P2, S1
cmovl S1, P2
cmovl P2, P0
cmp S1, P1
cmovge S2, P1
cmovge P1, S1
cmovg S1, S2
cmp P3, P2
mov S0, P3
