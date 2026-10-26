# n=5 model=out iset=I1 prefix14_class=4608
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
mov S0, P2
cmp P1, P0
cmovle P3, P0
mov S2, S1
cmovl P0, P1
cmovle P1, P3
cmp P1, S1
cmovg S2, P1
cmovl S1, P1
cmp P0, S0
