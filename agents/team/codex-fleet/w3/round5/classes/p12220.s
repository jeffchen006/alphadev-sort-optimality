# n=5 model=out iset=I1 prefix14_class=12220
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovle P3, S1
mov S2, P0
cmp P2, S2
cmovl S2, P2
cmovg P0, P2
cmp P3, P1
cmovl P2, P1
