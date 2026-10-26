# n=5 model=out iset=I1 prefix14_class=12327
cmp P0, P2
mov S0, P3
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P3, P1
cmovg S0, P1
cmovle P3, P1
cmp P2, S0
cmovg S1, S0
cmovle S1, P2
cmovl P2, S0
mov S1, P0
cmp P3, S1
