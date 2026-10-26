# n=5 model=out iset=I1 prefix14_class=11347
mov S2, P3
cmp P0, S2
cmovg S2, P0
cmovg P0, P3
cmp P2, P1
cmovle P3, P1
cmovg P3, P2
cmovle P1, P2
cmp S2, P3
cmovl S1, S2
cmovle S2, P3
cmovl P3, S1
mov P2, P0
cmp P1, P2
