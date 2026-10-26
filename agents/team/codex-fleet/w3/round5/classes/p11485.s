# n=5 model=out iset=I1 prefix14_class=11485
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
mov S2, P3
cmp P1, P3
cmovl P3, P1
cmovle P1, S2
mov S2, P0
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P1, S2
