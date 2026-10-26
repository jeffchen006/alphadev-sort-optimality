# n=5 model=out iset=I1 prefix14_class=4324
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovle P2, P3
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
cmovle P1, S1
cmp P0, S2
cmovle S0, P0
cmovle P0, S2
cmovle S2, S0
cmp P1, P2
cmovl P3, P2
