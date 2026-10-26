# n=5 model=out iset=I1 prefix14_class=11035
mov S1, P0
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
cmovl P2, S0
cmp P0, P1
cmovle P0, P1
cmovle P1, S1
mov S1, P3
cmp P0, S1
cmovle S1, P0
cmovle P0, P3
cmp P1, P2
cmovle P0, P1
