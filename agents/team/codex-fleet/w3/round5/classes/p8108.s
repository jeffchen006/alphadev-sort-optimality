# n=5 model=out iset=I1 prefix14_class=8108
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
mov S0, P2
mov S1, P0
cmovle P1, S2
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmp P0, P2
cmovg S1, P2
cmovl P0, P2
mov P2, P1
cmp P2, P3
