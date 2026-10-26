# n=5 model=out iset=I1 prefix14_class=13533
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovg S1, P3
cmp P0, P2
mov P3, P2
cmovle P3, P0
cmovl P0, P2
cmp P3, S1
cmovle S0, P3
cmovl P3, S1
cmovle S1, S0
mov S1, P0
cmp P0, P1
