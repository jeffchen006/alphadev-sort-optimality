# n=5 model=out iset=I1 prefix14_class=13349
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
mov S2, P2
cmp P3, P2
cmovle P2, P3
mov S0, P1
cmovg S2, P3
cmp P2, P1
cmovg S0, P2
cmovl P1, P2
cmp P0, S2
mov P2, S0
