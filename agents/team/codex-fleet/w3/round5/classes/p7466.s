# n=5 model=out iset=I1 prefix14_class=7466
mov S0, P3
mov S1, P2
cmp P0, P3
cmovl P3, P0
cmovg S0, P0
cmp P1, S1
cmovl S1, P1
cmovle P1, P2
cmp P3, S1
cmovl P2, P3
cmovle P3, S1
cmovl S1, P2
cmp P1, S0
mov S2, S0
