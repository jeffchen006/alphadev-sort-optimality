# n=5 model=out iset=I1 prefix14_class=8309
cmp P1, P0
cmovl S0, P1
cmovle P1, P0
mov S1, P2
cmovl P0, S0
cmp P2, P3
cmovg S1, P3
cmovl P2, P3
cmp P0, S1
cmovle P3, P0
cmovle P0, S1
cmovg P3, S1
cmp P1, P2
cmovl S1, P2
