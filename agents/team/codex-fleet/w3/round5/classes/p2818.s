# n=5 model=out iset=I1 prefix14_class=2818
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovl P3, S0
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovle S1, P2
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
mov P2, S1
cmovl P0, S2
cmp S1, P1
