# n=5 model=out iset=I1 prefix14_class=8973
mov S0, P3
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmp P1, P2
cmovle P3, P1
cmovl P1, P2
mov S1, S0
cmovle P2, P3
cmp P1, S1
cmovle S0, P1
cmovg S1, P1
mov P1, P0
cmp P1, P2
