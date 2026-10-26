# n=5 model=out iset=I1 prefix14_class=3623
cmp P2, P3
mov S2, P1
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovle P1, S2
cmp P3, P1
cmovl P1, P3
cmovg S2, P3
mov P1, P2
cmp P2, P0
