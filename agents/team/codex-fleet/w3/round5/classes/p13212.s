# n=5 model=out iset=I1 prefix14_class=13212
cmp P2, P1
mov S1, P2
cmovle S1, P1
cmovle P1, P2
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovle P3, S2
mov S0, P1
cmp P0, S0
cmovle S0, P0
cmovl P0, P1
cmp P3, S1
mov P1, S1
