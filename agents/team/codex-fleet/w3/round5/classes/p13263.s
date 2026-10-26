# n=5 model=out iset=I1 prefix14_class=13263
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
mov S2, P0
cmp P0, P3
cmovl P0, P3
cmovle P3, S2
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
cmp P0, P1
mov S2, P0
