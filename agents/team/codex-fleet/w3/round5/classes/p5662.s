# n=5 model=out iset=I1 prefix14_class=5662
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
mov S1, P3
cmovle P1, S0
cmp S1, P0
cmovle S1, P0
cmovl P0, P3
cmp P0, P2
mov P3, P2
cmovle P3, P0
cmovle P0, P2
cmp S1, P1
cmovle S0, S1
