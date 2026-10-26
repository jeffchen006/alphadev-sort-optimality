# n=5 model=out iset=I1 prefix14_class=10495
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
mov S2, P2
cmovl P3, S1
cmp P0, S2
cmovg P2, P0
cmovle S2, P0
cmp P2, P3
cmovle P0, P3
mov S0, S2
cmovl P3, P2
cmovle P2, P0
cmp P1, S2
