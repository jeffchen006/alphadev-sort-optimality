# n=5 model=out iset=I1 prefix14_class=3370
cmp P3, P1
mov S2, P0
mov S0, P1
cmovl P1, P3
cmovg S0, P3
cmp P2, P0
cmovg P0, P2
cmovl S2, P2
cmp P1, S2
cmovge S1, P1
cmovg P1, S2
cmovge S2, S1
cmp P0, S0
mov P3, S2
