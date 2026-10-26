# n=5 model=out iset=I1 prefix14_class=10471
mov S2, P1
cmp P2, P1
mov S1, P3
cmovle P1, P2
cmovl P2, S2
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmp P0, P2
cmovle P3, P2
mov S2, S1
cmovl P2, P0
cmovle P0, P3
mov P0, P2
