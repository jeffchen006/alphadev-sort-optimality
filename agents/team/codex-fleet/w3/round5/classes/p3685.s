# n=5 model=out iset=I1 prefix14_class=3685
mov S1, P0
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
mov S2, P2
cmp P1, P3
cmovl P0, P1
cmovle P1, P3
cmovl P3, P0
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
mov P2, S1
cmp P1, P2
