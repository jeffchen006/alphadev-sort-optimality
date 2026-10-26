# n=5 model=out iset=I1 prefix14_class=1404
mov S2, P1
cmp P2, P0
cmovl S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, S2
cmovl S2, P3
cmovg P1, P3
cmp P2, P1
mov P3, P1
cmovl P3, P2
cmovl P2, P1
mov P1, P3
cmp P0, S2
