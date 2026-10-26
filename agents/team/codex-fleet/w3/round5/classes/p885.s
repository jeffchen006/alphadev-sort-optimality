# n=5 model=out iset=I1 prefix14_class=885
cmp P3, P0
cmovl S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
cmovg P1, S2
mov S1, P0
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp S1, P2
