# n=5 model=out iset=I1 prefix14_class=7361
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
mov S1, P1
cmovl P3, S2
mov S0, P2
cmp P0, P2
cmovg P2, P0
cmovle S0, P0
cmp P3, S0
cmovle S2, P3
cmovle P3, S0
cmovl S0, S2
cmp P2, P1
