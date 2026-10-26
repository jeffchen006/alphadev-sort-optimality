# n=5 model=out iset=I1 prefix14_class=10991
mov S2, P1
cmp P0, S2
cmovle P1, P0
cmovl P0, S2
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
mov S0, P3
cmovl P2, S2
cmp P3, P0
cmovl S0, P0
cmovl P0, P3
cmp P1, P2
cmovl P3, P2
