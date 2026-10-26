# n=5 model=out iset=I1 prefix14_class=5154
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
mov S2, P3
cmovl P1, S1
cmp P3, P0
cmovg S2, P0
cmovg P0, P3
cmp P1, P2
cmovg P3, P2
