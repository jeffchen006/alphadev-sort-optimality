# n=5 model=out iset=I1 prefix14_class=1993
mov S2, P0
mov S1, P3
cmp P3, P1
cmovl S1, P1
cmovg P3, P1
cmp P2, P0
cmovg P0, P2
cmovl S2, P2
cmovl P2, P0
cmp P2, S1
cmovle P0, S1
cmovle S1, P2
cmp P3, S2
mov P0, S1
