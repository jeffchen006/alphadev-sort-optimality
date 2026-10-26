# n=5 model=out iset=I1 prefix14_class=6059
mov S2, P1
cmp P1, P0
cmovl S2, P0
cmovle P0, P1
cmp P3, P2
cmovle S1, P2
mov P1, S2
cmovle P2, P3
cmovle P3, S1
cmp P1, P3
cmovle P1, P3
cmovl P3, S2
mov P1, P0
cmp P1, P2
