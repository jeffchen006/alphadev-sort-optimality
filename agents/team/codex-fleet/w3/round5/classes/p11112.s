# n=5 model=out iset=I1 prefix14_class=11112
mov S2, P3
cmp P2, P3
cmovle S2, P2
cmovg P3, P2
cmp P1, P0
mov P2, P1
cmovle P1, P0
cmovl P0, P2
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
mov P2, S2
cmovle P1, S1
cmp S2, P0
