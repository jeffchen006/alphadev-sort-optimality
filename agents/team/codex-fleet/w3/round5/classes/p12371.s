# n=5 model=out iset=I1 prefix14_class=12371
mov S2, P3
cmp P2, P0
mov S1, P0
cmovl P0, P2
cmovle P2, S1
cmp P1, P3
cmovle P3, P1
cmovle P1, S2
cmp P0, P3
cmovle S0, P3
mov S2, P1
cmovl P3, P0
cmovle P0, S0
cmp P2, P1
