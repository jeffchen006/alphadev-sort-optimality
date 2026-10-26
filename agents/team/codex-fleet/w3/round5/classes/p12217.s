# n=5 model=out iset=I1 prefix14_class=12217
cmp P1, P0
cmovl S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P2, P3
mov S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P3, P0
cmovg S2, P0
cmovg P0, P3
cmovle S2, P3
cmp P2, P1
mov S2, P0
