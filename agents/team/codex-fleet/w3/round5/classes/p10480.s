# n=5 model=out iset=I1 prefix14_class=10480
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovl P0, S0
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovle P2, P3
cmp P0, P2
cmovle P3, P2
cmovl P2, P0
cmovl P0, P3
mov P0, P2
cmp S2, P1
