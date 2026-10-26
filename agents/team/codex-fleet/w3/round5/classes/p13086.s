# n=5 model=out iset=I1 prefix14_class=13086
mov S2, P3
cmp P3, P1
cmovl S2, P1
cmovg P3, P1
cmovl P1, P3
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P0, P1
cmovle P3, P0
cmovg P1, P0
cmp P2, S2
cmovle S1, P2
