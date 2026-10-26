# n=5 model=out iset=I1 prefix14_class=8725
cmp P2, P0
mov S0, P1
cmovg S2, P2
cmovg P2, P0
cmovg P0, S2
cmp P1, P3
cmovl P1, P3
cmovl P3, S0
mov S1, P0
cmp P1, S1
cmovge S1, P1
cmovl P0, P1
mov P1, P3
cmp P1, P2
