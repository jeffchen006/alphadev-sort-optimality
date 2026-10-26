# n=5 model=out iset=I1 prefix14_class=3364
mov S2, P1
mov S0, P0
cmp P3, P0
cmovl P0, P3
cmovg S0, P3
cmp P2, P1
cmovl S2, P2
cmovg P1, P2
cmp P0, S2
cmovge S1, P0
cmovg P0, S2
cmovg S2, S1
mov P3, S2
cmp P1, S0
