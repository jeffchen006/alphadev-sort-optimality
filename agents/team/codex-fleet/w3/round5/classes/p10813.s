# n=5 model=out iset=I1 prefix14_class=10813
mov S2, P3
cmp P2, S2
cmovg P3, P2
cmovl S2, P2
cmp P0, P1
cmovg S1, P0
cmovle S1, P1
cmovl P1, P0
cmp P3, S1
cmovle P2, P3
cmovle P3, S1
cmovle S1, P2
mov P3, P1
cmp S2, P1
