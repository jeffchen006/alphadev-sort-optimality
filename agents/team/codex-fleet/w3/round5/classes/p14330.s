# n=5 model=out iset=I1 prefix14_class=14330
cmp P2, P0
cmovg S1, P0
cmovg P0, P2
cmovle S1, P2
cmp P3, P1
cmovle S2, P1
cmovle P1, P3
mov P2, P1
cmovl P3, S2
cmp S1, P1
cmovl P2, S1
cmovl S1, P1
cmp P0, P3
cmovg P1, S1
