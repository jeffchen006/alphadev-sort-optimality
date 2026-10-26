# n=5 model=out iset=I1 prefix14_class=3811
mov S1, P2
cmp S1, P1
cmovg P2, P1
cmovg P1, S1
cmp P0, P3
mov S2, P3
cmovl P3, P0
cmovle P0, S2
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
mov S1, P0
cmovl P2, S2
cmp P1, S1
