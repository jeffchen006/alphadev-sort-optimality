# n=5 model=out iset=I1 prefix14_class=3611
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovle P3, P0
mov P0, P2
cmp P1, P0
cmovl P2, P1
cmovle P1, P0
cmovl P0, P2
cmp P3, P2
cmovl P0, P3
cmovl P3, P2
cmp P1, S0
cmovle P2, P3
