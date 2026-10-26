# n=5 model=out iset=I1 prefix14_class=8506
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov S1, P1
cmovl P0, S0
cmp P1, P2
cmovl P1, P2
cmovle P2, S1
mov S1, P1
cmp P0, P1
cmovg P1, P0
cmovl S1, P0
cmp P2, P3
cmovle S0, P2
