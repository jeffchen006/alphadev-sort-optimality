# n=5 model=out iset=I1 prefix14_class=7642
cmp P1, P2
mov S2, P0
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
cmp P3, S2
cmovl P0, P3
cmovg S2, P3
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmovl P0, S1
cmp P1, S2
cmovl S1, S2
