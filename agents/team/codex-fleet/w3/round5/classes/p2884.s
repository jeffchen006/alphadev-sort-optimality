# n=5 model=out iset=I1 prefix14_class=2884
cmp P2, P0
cmovle S2, P2
mov S0, P1
cmovl P2, P0
mov S1, P2
cmovl P0, S2
cmp P1, P3
cmovle P1, P3
cmovg S0, P3
cmp P1, S1
cmovl P2, P1
cmovl P1, S1
cmp P0, S0
mov S1, P2
