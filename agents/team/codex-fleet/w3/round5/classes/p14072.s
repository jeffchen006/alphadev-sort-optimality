# n=5 model=out iset=I1 prefix14_class=14072
cmp P2, P0
cmovl S0, P2
cmovl P2, P0
mov S2, P1
cmovl P0, S0
mov S1, P2
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmp S1, P3
cmovg P2, P3
cmovl S1, P3
cmp P0, S2
cmovl S1, S2
