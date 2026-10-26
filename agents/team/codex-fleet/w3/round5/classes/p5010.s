# n=5 model=out iset=I1 prefix14_class=5010
mov S1, P2
mov S2, P3
cmp P2, P0
cmovle P2, P0
cmovl P0, S1
cmp P1, S2
cmovg S2, P1
cmovl P3, P1
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
mov P1, S2
cmp P1, P2
