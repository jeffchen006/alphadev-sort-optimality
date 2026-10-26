# n=5 model=out iset=I1 prefix14_class=4600
mov S1, P0
cmp P1, P0
cmovg S1, P1
cmovle P0, P1
cmp P3, P2
cmovle P1, P2
cmovl P2, P3
cmovl P3, P1
mov S2, S1
cmp P3, S1
cmovl S1, P3
cmovle P3, S2
mov S0, P2
cmp P0, S0
