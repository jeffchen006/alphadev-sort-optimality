# n=5 model=out iset=I1 prefix14_class=10371
cmp P0, P2
mov S1, P3
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
cmovg S1, P1
cmp P0, P3
cmovg S0, P0
cmovg P0, P3
cmovg P3, S0
cmp P2, S1
