# n=5 model=out iset=I1 prefix14_class=13210
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovle P3, S2
mov S1, P2
cmp P0, S1
cmovle S1, P0
cmovle P0, P2
mov P2, P3
cmp P1, P2
