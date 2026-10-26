# n=5 model=out iset=I1 prefix14_class=10359
mov S0, P2
cmp P3, P2
cmovl P2, P3
mov S1, P0
cmovg S0, P3
cmp P1, P0
cmovle P0, P1
cmovl P1, S1
cmp P1, S0
cmovle P3, S0
cmovle S0, P1
mov S2, S0
cmovl P1, P3
mov S1, P2
