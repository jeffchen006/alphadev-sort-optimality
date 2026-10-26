# n=5 model=out iset=I1 prefix14_class=8465
cmp P0, P2
mov S0, P2
mov S2, P3
cmovle P2, P0
cmovl P0, S0
cmp P3, P1
cmovl P3, P1
cmovle P1, S2
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
mov S1, P1
cmovle P0, S0
cmp S1, P2
