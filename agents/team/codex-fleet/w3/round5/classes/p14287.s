# n=5 model=out iset=I1 prefix14_class=14287
mov S0, P3
mov S1, P2
cmp P0, S1
cmovl P2, P0
cmovl P0, S1
cmp P1, S0
cmovge P3, P1
cmovg P1, S0
cmp P0, P3
cmovge S2, P3
cmovl S2, P0
cmovge P3, P0
cmovg S1, P2
cmp P2, P1
