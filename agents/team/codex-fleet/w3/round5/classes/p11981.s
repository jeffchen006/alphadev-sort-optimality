# n=5 model=out iset=I1 prefix14_class=11981
cmp P3, P0
cmovle S1, P3
mov S0, P1
cmovle P3, P0
cmovg S1, P0
cmp S0, P2
cmovl P1, P2
cmovl P2, S0
cmp P2, S1
cmovle P0, S1
cmovle S1, P2
cmovle P2, P0
cmp P3, P1
cmovle P0, P3
