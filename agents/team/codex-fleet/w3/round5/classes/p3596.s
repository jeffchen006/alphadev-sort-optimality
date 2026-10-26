# n=5 model=out iset=I1 prefix14_class=3596
mov S1, P3
cmp S1, P1
mov S0, P2
cmovle S1, P1
cmovle P1, P3
cmp P0, P2
cmovle P2, P0
cmovle P0, S0
cmp P1, P2
cmovl P3, P2
cmovl P2, P1
cmovl P1, P3
cmp P0, S1
mov P3, P0
