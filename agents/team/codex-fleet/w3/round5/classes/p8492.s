# n=5 model=out iset=I1 prefix14_class=8492
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovle P1, P3
cmp P2, P0
mov P3, P1
cmovle S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P3, P2
cmovg P3, P2
cmovle P1, P2
mov P1, P0
cmp S1, P1
