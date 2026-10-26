# n=5 model=out iset=I1 prefix14_class=4344
cmp P1, P3
cmovle S0, P1
cmovl P1, P3
cmovg S0, P3
cmp P0, P2
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
cmp S0, P2
mov S2, S0
cmovle S0, P2
cmovle P2, S2
mov P2, P0
cmp P1, P0
