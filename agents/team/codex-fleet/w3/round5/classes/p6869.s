# n=5 model=out iset=I1 prefix14_class=6869
cmp P2, P1
mov S2, P1
mov S1, P0
cmovle S2, P2
cmovl P2, P1
cmp S1, P3
cmovl S1, P3
mov P1, P2
cmovle P3, P0
cmp S1, P2
cmovg P1, S1
cmovle P2, S1
cmp S2, P3
cmovle S1, P3
