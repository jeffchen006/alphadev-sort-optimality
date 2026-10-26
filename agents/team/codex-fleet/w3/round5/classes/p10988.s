# n=5 model=out iset=I1 prefix14_class=10988
mov S0, P2
cmp P1, S0
cmovl P2, P1
cmovle P1, S0
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
mov S2, P3
cmovl P0, S0
cmp S2, P1
cmovle S2, P1
cmovle P1, P3
cmp P2, P0
cmovl P3, P0
