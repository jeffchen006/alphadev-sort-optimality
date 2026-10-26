# n=5 model=out iset=I1 prefix14_class=12419
mov S0, P0
cmp S0, P1
cmovle S0, P1
cmovle P1, P0
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovle P3, S1
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
cmp S0, P3
mov S2, S0
