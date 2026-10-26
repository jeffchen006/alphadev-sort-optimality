# n=5 model=out iset=I1 prefix14_class=12435
mov S0, P0
cmp S0, P3
cmovle S0, P3
cmovle P3, P0
cmp P1, P2
mov P0, P2
cmovle P0, P1
cmovl P1, P2
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmovle P3, P2
cmp P1, S0
cmovle P0, P1
