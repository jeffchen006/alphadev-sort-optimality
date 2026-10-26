# n=5 model=out iset=I1 prefix14_class=8322
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovg S1, P0
mov S0, P1
cmp P1, S1
cmovle S0, S1
cmovle S1, P1
mov S1, P3
cmp P3, P2
