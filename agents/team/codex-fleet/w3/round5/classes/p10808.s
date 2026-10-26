# n=5 model=out iset=I1 prefix14_class=10808
cmp P0, P3
mov S1, P3
cmovg P3, P0
cmovl S1, P0
cmp P2, P1
mov S0, P2
cmovle P2, P1
cmovle P1, S0
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovl P2, S0
cmp P1, S1
cmovle P0, S1
