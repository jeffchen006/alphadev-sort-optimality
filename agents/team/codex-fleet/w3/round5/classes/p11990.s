# n=5 model=out iset=I1 prefix14_class=11990
cmp P0, P2
mov S1, P0
cmovg P0, P2
cmovl S1, P2
mov S2, P3
cmp S2, P1
cmovl P3, P1
cmovl P1, S2
cmp P1, P0
cmovle P2, P0
cmovle P0, P1
cmovl P1, P2
cmp P3, S1
cmovle S2, P3
