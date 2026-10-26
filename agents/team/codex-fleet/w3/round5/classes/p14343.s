# n=5 model=out iset=I1 prefix14_class=14343
cmp P1, P0
mov S2, P1
cmovle P1, P0
cmovl P0, S2
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P2, P0
mov S2, P2
cmovg S2, P0
cmovg P0, P2
mov P2, P3
cmp P1, P2
