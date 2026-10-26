# n=5 model=out iset=I1 prefix14_class=10250
mov S1, P0
cmp P1, P3
mov S0, P3
cmovl S0, P1
cmovle P1, P3
cmp P0, P2
cmovle S1, P2
cmovg P0, P2
cmp P1, S1
cmovl P3, P1
cmovle P1, S1
cmovl S1, P3
cmp P0, S0
cmovg P2, P0
