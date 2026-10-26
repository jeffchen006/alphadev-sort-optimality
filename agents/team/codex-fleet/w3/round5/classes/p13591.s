# n=5 model=out iset=I1 prefix14_class=13591
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
mov S1, P1
cmp P3, P1
cmovl P1, P3
cmovl P3, S1
cmovl S1, P1
cmp P0, S1
cmovle P1, P0
cmovle P0, S1
mov S2, P0
cmp P2, P3
