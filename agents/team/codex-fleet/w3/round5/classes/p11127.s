# n=5 model=out iset=I1 prefix14_class=11127
cmp P1, P0
mov S0, P2
cmovle S2, P1
cmovl P1, P0
cmovle P0, S2
mov S1, P1
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
mov S1, P3
cmp P0, P2
