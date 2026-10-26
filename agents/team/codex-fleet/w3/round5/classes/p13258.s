# n=5 model=out iset=I1 prefix14_class=13258
mov S1, P2
cmp P1, S1
cmovle S1, P1
mov S0, P0
cmovl P1, P2
cmp S0, P3
cmovl P0, P3
cmovle P3, S0
cmp S1, P3
cmovle S0, P3
cmovle P3, S1
cmovl S1, S0
cmp P0, P1
mov S2, P0
