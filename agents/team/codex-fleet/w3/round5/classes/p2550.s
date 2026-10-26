# n=5 model=out iset=I1 prefix14_class=2550
mov S2, P2
mov S0, P1
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P1, P3
cmovle S0, P3
cmovle P3, P1
cmp S2, S0
cmovl P2, S0
cmovle S0, S2
mov P2, P3
cmp P0, P3
