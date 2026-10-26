# n=5 model=out iset=I1 prefix14_class=13272
cmp P1, P2
cmovl S1, P2
mov S2, P0
cmovle P2, P1
cmovl P1, S1
cmp P0, P3
cmovl P0, P3
cmovl P3, S2
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovl P2, S0
cmp P0, P1
cmovg P3, P0
