# n=5 model=out iset=I1 prefix14_class=3605
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovl P2, P3
cmp P0, P1
cmovle P3, P1
cmovle P1, P0
cmovle P0, P3
cmp P2, P1
cmovle P3, P1
cmovle P1, P2
cmovle P2, P3
cmp P0, S0
mov S2, P0
