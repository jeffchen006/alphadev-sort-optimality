# n=5 model=out iset=I1 prefix14_class=11980
mov S1, P3
cmp P3, P0
cmovg S1, P0
mov S2, P1
cmovl P3, P0
cmp P1, P2
cmovle P1, P2
cmovle P2, S2
cmp P2, S1
cmovle S0, S1
cmovl S1, P2
cmovl P2, S0
cmp P1, P3
cmovl S0, P1
