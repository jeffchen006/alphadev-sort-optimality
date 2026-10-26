# n=5 model=out iset=I1 prefix14_class=6187
mov S1, P2
mov S2, P3
cmp P1, S2
cmovle P3, P1
cmovl P1, S2
cmp P0, S1
cmovg S1, P0
cmovl P2, P0
cmp P1, S1
cmovle P0, P1
mov S0, P2
cmovle P1, S1
cmovl S1, P0
cmp P2, P3
