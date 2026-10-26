# n=5 model=out iset=I1 prefix14_class=5594
mov S1, P3
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
mov P3, P1
cmp P2, P0
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P1, P0
cmovg P3, P0
cmovg P0, P1
mov S0, S1
cmp S0, P2
