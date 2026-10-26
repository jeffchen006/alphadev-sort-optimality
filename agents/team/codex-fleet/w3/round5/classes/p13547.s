# n=5 model=out iset=I1 prefix14_class=13547
cmp P0, P2
cmovg S0, P2
cmovle S0, P0
cmovl P0, P2
cmp P3, P1
cmovle P2, P1
cmovl P1, P3
cmovl P3, P2
mov S2, S0
cmp P1, S0
cmovle S2, P1
cmovle P1, S0
mov S1, P0
cmp P3, P0
