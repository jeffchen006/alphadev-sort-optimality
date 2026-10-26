# n=5 model=out iset=I1 prefix14_class=10493
mov S2, P0
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P2, S2
cmovg P0, P2
cmovle S2, P2
cmp P0, P3
cmovle P2, P3
mov S0, P1
cmovl P3, P0
cmovle P0, P2
cmp S2, P1
