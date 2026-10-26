# n=5 model=out iset=I1 prefix14_class=8918
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovl P2, S2
mov S1, P3
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
cmp P0, P2
mov P3, P0
cmovg P3, P2
cmovle P0, P2
mov P0, P1
cmp S1, P0
