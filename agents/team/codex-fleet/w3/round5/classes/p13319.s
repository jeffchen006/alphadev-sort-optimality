# n=5 model=out iset=I1 prefix14_class=13319
cmp P2, P0
cmovg S2, P2
cmovg P2, P0
cmovg P0, S2
cmp P1, P3
mov S1, P2
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P3, S1
cmovl P2, P3
cmovg S1, P3
cmp P0, P1
cmovle P2, P0
