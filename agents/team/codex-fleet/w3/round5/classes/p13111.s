# n=5 model=out iset=I1 prefix14_class=13111
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
cmovl P3, S1
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
mov S2, P0
cmp S2, P2
cmovl S2, P2
cmovl P2, P0
cmovle P0, S2
mov S0, P1
