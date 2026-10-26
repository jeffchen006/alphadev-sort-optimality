# n=5 model=out iset=I1 prefix14_class=10993
mov S2, P0
cmp P1, S2
cmovle S2, P1
cmovle P1, P0
cmp P2, P3
cmovle P0, P2
cmovle P2, P3
cmovle P3, P0
mov S1, P2
cmp S1, P1
cmovl S1, P1
cmovl P1, P2
cmp S2, P3
cmovl P2, P3
