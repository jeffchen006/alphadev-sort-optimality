# n=5 model=out iset=I1 prefix14_class=14032
mov S1, P0
cmp S1, P3
cmovle S1, P3
cmovg P0, P3
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
mov P3, P1
cmovl P2, S2
cmp P3, S1
cmovl P1, S1
mov P1, P2
cmovl S1, P3
cmp P0, P1
