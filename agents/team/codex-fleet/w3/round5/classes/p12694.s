# n=5 model=out iset=I1 prefix14_class=12694
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovg P3, S2
mov S0, P3
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P0, P3
mov S1, P1
cmovg S0, P0
cmovg P0, P3
cmp P2, S1
