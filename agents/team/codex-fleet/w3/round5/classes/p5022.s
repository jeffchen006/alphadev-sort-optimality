# n=5 model=out iset=I1 prefix14_class=5022
cmp P2, P3
cmovl S1, P3
mov S2, P1
cmovl P3, P2
cmovl P2, S1
cmp P0, S2
cmovle P1, P0
cmovle P0, S2
mov S0, P2
cmovl S2, P1
cmp P3, P1
cmovle S2, P3
cmovg P1, P3
cmp S0, P0
