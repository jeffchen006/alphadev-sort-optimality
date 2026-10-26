# n=5 model=out iset=I1 prefix14_class=14482
cmp P0, P3
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
mov S2, P3
cmovle S1, P2
cmovg S1, P1
cmovle P2, P1
cmp P3, S1
cmovle P3, S1
cmovl S1, S2
cmp P2, P0
mov S2, P3
