# n=5 model=out iset=I1 prefix14_class=3809
mov S1, P2
cmp S1, P3
cmovg P2, P3
cmovg P3, S1
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
mov S1, P0
cmovl P2, S2
cmp P3, P0
