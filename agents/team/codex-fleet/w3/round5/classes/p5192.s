# n=5 model=out iset=I1 prefix14_class=5192
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovl P1, S1
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P3, P1
mov S1, P3
cmovg P3, P1
cmovg P1, S1
mov P3, P0
cmp P2, P0
