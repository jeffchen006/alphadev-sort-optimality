# n=5 model=out iset=I1 prefix14_class=6042
cmp P1, P3
cmovg S2, P1
cmovle S2, P3
mov S1, P0
cmovle P3, P1
mov P1, S2
cmp P2, P0
cmovle P0, P2
cmovle P2, S1
cmp P2, S2
cmovle S2, P2
cmovg P1, P2
cmp P0, P3
cmovl P2, P0
