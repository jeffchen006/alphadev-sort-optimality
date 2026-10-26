# n=5 model=out iset=I1 prefix14_class=9988
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P0, P1
mov S2, P3
cmovle S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P0, S2
mov S1, P1
cmovle S2, P0
cmovl P0, P3
cmp S1, P2
