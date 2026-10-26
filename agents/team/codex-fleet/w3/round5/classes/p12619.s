# n=5 model=out iset=I1 prefix14_class=12619
mov S0, P3
cmp P2, S0
cmovle P3, P2
cmovle P2, S0
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
mov S1, P2
cmovle P0, S0
cmp P1, P3
cmovl S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P0, P2
