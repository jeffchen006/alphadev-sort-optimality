# n=5 model=out iset=I1 prefix14_class=9986
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmovg S2, P3
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P1, S2
mov S1, P0
cmovl P3, S2
cmovle S2, P1
cmovl P1, P3
cmp P0, P2
