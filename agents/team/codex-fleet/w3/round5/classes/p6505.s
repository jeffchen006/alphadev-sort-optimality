# n=5 model=out iset=I1 prefix14_class=6505
cmp P0, P1
cmovle S2, P1
cmovg S2, P0
cmovl P1, P0
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovg S1, P2
cmp S2, S1
mov P2, S1
cmovle S1, S2
cmovl S2, P2
cmp P1, P3
cmovle P2, S1
