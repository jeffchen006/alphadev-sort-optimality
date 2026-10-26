# n=5 model=out iset=I1 prefix14_class=12250
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P3, P1
mov P0, P1
cmovle P0, P3
cmovg P1, P3
cmp P0, S2
cmovle S1, P0
cmovl P0, S2
cmovl S2, S1
mov S2, P0
cmp P2, P1
