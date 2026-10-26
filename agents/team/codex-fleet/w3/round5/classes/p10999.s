# n=5 model=out iset=I1 prefix14_class=10999
mov S1, P0
cmp P0, P1
cmovl S1, P1
cmovg P0, P1
cmp P3, P2
cmovle S0, P3
mov S2, S1
cmovl P3, P2
cmovle P2, S0
cmp P3, S2
cmovl S2, P3
cmovg S1, P3
cmp P0, P2
cmovle P3, P2
