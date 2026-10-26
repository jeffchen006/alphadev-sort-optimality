# n=5 model=out iset=I1 prefix14_class=13206
cmp P3, P0
mov S0, P2
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
cmovle P2, P1
cmovle P1, S0
mov S0, P2
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmp P1, P3
mov S0, P1
