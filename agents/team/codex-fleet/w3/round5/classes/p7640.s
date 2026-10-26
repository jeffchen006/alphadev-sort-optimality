# n=5 model=out iset=I1 prefix14_class=7640
mov S2, P0
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P2, P0
cmovg P0, P2
cmovl S2, P2
cmp S2, P3
mov P2, S2
cmovle S2, P3
cmovl P3, P2
cmp P0, P1
cmovl P2, P1
