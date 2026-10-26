# n=5 model=out iset=I1 prefix14_class=11140
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P2, P0
mov S1, P2
cmovl P2, P0
cmovg S1, P0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
mov P3, P1
cmovle P2, S2
cmp P3, S1
