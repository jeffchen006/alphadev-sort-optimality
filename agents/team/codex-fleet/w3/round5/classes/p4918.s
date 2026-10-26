# n=5 model=out iset=I1 prefix14_class=4918
mov S0, P2
cmp P1, S0
cmovl P2, P1
cmovl P1, S0
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
mov S0, P3
cmp P2, S0
cmovle P3, P2
cmovle P2, S0
mov S2, P0
cmp S2, P1
