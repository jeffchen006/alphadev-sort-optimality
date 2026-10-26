# n=5 model=out iset=I1 prefix14_class=10484
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
mov S1, P3
cmp P2, P3
cmovl S1, P2
mov S0, P1
cmovg P3, P2
cmp P3, P0
cmovl P2, P0
cmovle P0, P3
cmovl P3, P2
cmp S1, S0
