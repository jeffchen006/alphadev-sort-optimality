# n=5 model=out iset=I1 prefix14_class=12611
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovle P1, P3
cmp P0, P2
mov S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P2, S0
cmovle S1, S0
cmovle S0, P2
cmovl P2, S1
mov S0, P0
cmp P1, P0
