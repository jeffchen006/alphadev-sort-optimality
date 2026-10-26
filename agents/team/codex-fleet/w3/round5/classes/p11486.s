# n=5 model=out iset=I1 prefix14_class=11486
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
mov S2, P3
cmp P1, P3
cmovl P3, P1
cmovl P1, S2
mov S2, P0
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P1, S2
