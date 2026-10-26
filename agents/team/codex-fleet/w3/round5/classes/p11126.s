# n=5 model=out iset=I1 prefix14_class=11126
cmp P1, P0
cmovle S2, P1
mov S0, P2
cmovl P1, P0
cmovl P0, S2
cmp P3, S0
mov S1, P1
cmovl P2, P3
cmovl P3, S0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
mov S0, P3
cmp P0, P2
