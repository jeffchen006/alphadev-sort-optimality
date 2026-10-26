# n=5 model=out iset=I1 prefix14_class=6668
mov S0, P3
mov S2, P2
cmp P1, P3
cmovle P3, P1
cmovle P1, S0
cmp P0, S2
mov S1, P1
cmovl P2, P0
cmovle P0, S2
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
cmp P3, P2
cmovl S0, P3
