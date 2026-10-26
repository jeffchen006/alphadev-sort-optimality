# n=5 model=out iset=I1 prefix14_class=7638
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
mov S0, P0
cmovl P3, S1
cmp P2, P0
cmovl P0, P2
cmovg S0, P2
cmp P0, P3
cmovle P2, P0
cmovl P0, P3
cmovl P3, P2
cmp P1, S0
cmovle P2, S0
