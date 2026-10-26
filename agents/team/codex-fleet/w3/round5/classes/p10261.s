# n=5 model=out iset=I1 prefix14_class=10261
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
mov S1, P0
cmovl P2, S2
cmp P0, P1
cmovg S1, P1
cmovle P0, P1
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
mov S2, P0
mov P1, P3
