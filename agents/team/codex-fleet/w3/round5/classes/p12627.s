# n=5 model=out iset=I1 prefix14_class=12627
mov S2, P3
cmp P0, S2
cmovle P3, P0
cmovl P0, S2
mov S2, P0
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P2, P0
