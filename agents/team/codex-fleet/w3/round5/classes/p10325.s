# n=5 model=out iset=I1 prefix14_class=10325
cmp P2, P3
mov S1, P3
cmovl P3, P2
cmovg S1, P2
mov S0, P1
cmp P0, S0
cmovg P1, P0
cmovl S0, P0
cmp P1, S1
cmovg P0, S1
cmovg S1, P1
mov S2, P3
cmovg P1, P0
cmp P3, S0
