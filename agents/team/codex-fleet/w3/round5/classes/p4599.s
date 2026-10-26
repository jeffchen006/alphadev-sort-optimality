# n=5 model=out iset=I1 prefix14_class=4599
mov S1, P3
cmp P1, P3
cmovg S1, P1
cmovle P3, P1
cmp P0, P2
cmovle P1, P2
cmovl P2, P0
cmovl P0, P1
mov S2, S1
cmp P0, S1
cmovl S1, P0
cmovle P0, S2
mov S0, P2
cmp P3, S0
