# n=5 model=out iset=I1 prefix14_class=14471
cmp P1, P0
cmovg S1, P1
cmovge P1, P0
mov S0, P3
cmovg P0, S1
cmp P3, P2
cmovl S0, P2
cmovg P3, P2
mov S2, P1
cmp P3, S2
cmovl P1, P3
cmovl P3, S2
cmovge S2, P3
cmp P0, S0
