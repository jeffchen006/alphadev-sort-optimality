# n=5 model=out iset=I1 prefix14_class=14157
cmp P1, P3
cmovl S2, P3
cmovl P3, P1
cmovl P1, S2
mov S1, P0
cmp P2, P0
mov S0, P1
cmovg S1, P2
cmovge P2, P0
cmp S0, S1
cmovge P1, S1
cmovge S1, S0
cmp P2, P3
cmovg S0, P2
