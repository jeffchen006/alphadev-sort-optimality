# n=5 model=out iset=I1 prefix14_class=553
cmp P1, P3
cmovg S0, P1
mov S1, P0
cmovg P1, P3
cmovg P3, S0
cmp P0, P2
cmovl P0, P2
cmovge S1, P2
mov S2, S1
cmp P1, S2
cmovge S2, P1
cmovl S1, P1
mov P1, P3
cmp P0, P3
