# n=5 model=out iset=I1 prefix14_class=11041
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovle P2, S2
mov S1, P3
cmp P3, P1
cmovle S1, P1
mov S0, P0
cmovl P1, P3
cmp S1, P0
cmovl P0, S1
cmovl S1, S0
cmp P1, P2
cmovg P3, P2
