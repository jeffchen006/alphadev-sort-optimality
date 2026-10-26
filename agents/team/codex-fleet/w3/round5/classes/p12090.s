# n=5 model=out iset=I1 prefix14_class=12090
cmp P3, P0
mov S1, P3
cmovg P3, P0
cmovle S1, P0
cmp P2, P1
mov P0, P2
cmovg P0, P1
cmovl P2, P1
cmp P0, P3
cmovl P1, P3
cmovle P3, P0
cmovl P0, P1
cmp S1, P2
cmovle P1, S1
