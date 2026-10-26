# n=5 model=out iset=I1 prefix14_class=6478
cmp P0, P1
mov S2, P3
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P2, S2
cmovl P3, P2
cmovg S2, P2
cmp P0, S2
cmovle P2, P0
cmovle P0, S2
cmovg P2, S2
cmp P3, P1
cmovle S2, P1
