# n=5 model=out iset=I1 prefix14_class=2315
mov S2, P0
mov S0, P3
cmp P1, P0
cmovle P0, P1
cmovle P1, S2
cmp P3, P2
mov S2, P0
cmovl P3, P2
cmovg S0, P2
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, S0
