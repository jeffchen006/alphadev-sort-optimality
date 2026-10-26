# n=5 model=out iset=I1 prefix14_class=1139
cmp P0, P1
mov S1, P3
cmovle S2, P0
cmovl P0, P1
cmovle P1, S2
cmp P2, P3
cmovg S1, P2
cmovg P2, P3
cmp P0, S1
cmovle P3, S1
cmovg P3, P0
cmovl S1, P0
cmp P1, P2
cmovl P0, P2
