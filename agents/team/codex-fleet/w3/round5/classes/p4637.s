# n=5 model=out iset=I1 prefix14_class=4637
mov S0, P3
mov S1, P1
cmp P2, P1
cmovg S1, P2
cmovle P1, P2
cmp P0, P3
cmovle P3, P0
cmovl P0, S0
cmp P0, S1
cmovle S2, P0
cmovl P0, S1
cmovg S2, S1
mov P0, P1
cmp P3, P1
