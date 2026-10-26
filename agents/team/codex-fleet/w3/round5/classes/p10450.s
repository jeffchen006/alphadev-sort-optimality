# n=5 model=out iset=I1 prefix14_class=10450
mov S2, P2
cmp P2, P1
mov S0, P3
cmovle P2, P1
cmovl P1, S2
cmp P0, S0
cmovl P3, P0
cmovl P0, S0
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovle P0, S2
mov S1, P3
cmp P1, S1
