# n=5 model=out iset=I1 prefix14_class=14266
mov S2, P0
cmp P1, P3
mov S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P2, S2
cmovle S2, P2
cmovle P2, P0
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovl P2, S1
mov S0, P2
mov P0, S2
