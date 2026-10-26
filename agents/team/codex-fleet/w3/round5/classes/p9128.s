# n=5 model=out iset=I1 prefix14_class=9128
mov S0, P2
cmp P2, P3
cmovg S0, P3
cmovl P2, P3
cmp P1, P0
cmovg P3, P1
cmovg P1, P0
mov S1, S0
mov S2, P2
cmovg P0, P3
cmp P1, S1
cmovl S0, P1
cmovge S1, P1
cmp P0, P2
