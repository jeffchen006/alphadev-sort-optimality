# n=5 model=out iset=I1 prefix14_class=13265
cmp P1, P2
mov S1, P2
cmovle P2, P1
cmovl P1, S1
mov S2, P0
cmp P0, P3
cmovle P0, P3
cmovl P3, S2
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P0, P1
cmovg S2, P0
