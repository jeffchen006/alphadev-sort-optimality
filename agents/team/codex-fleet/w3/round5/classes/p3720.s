# n=5 model=out iset=I1 prefix14_class=3720
mov S0, P1
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovl P0, S1
cmp S0, P3
cmovle P1, P3
cmovle P3, S0
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovle P3, P0
cmp P1, P2
mov P3, P2
