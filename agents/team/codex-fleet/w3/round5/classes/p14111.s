# n=5 model=out iset=I1 prefix14_class=14111
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
cmp P1, P2
cmovle S2, P2
cmovl P2, P1
cmovg S2, P1
cmp P3, S2
mov P1, P3
cmovl P1, S2
cmovle S2, P3
mov P1, P0
cmp P2, P1
