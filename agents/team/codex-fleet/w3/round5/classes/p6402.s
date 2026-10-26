# n=5 model=out iset=I1 prefix14_class=6402
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P3, P0
mov S0, P0
cmovge S0, P3
cmovl P0, P3
cmovl P3, S0
cmp P1, P3
cmovg S0, P1
cmovl P3, P1
cmp P0, P2
cmovl P1, P0
