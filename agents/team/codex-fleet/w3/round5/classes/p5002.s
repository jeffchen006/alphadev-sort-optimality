# n=5 model=out iset=I1 prefix14_class=5002
cmp P2, P3
cmovle S2, P3
mov S1, P0
cmovle P3, P2
cmovle P2, S2
cmp P1, S1
cmovl S1, P1
cmovg P0, P1
cmp S1, P3
mov S2, P2
cmovle P1, P3
cmovl P3, S1
cmovle S1, P1
cmp S2, P0
