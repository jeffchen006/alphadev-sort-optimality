# n=5 model=out iset=I1 prefix14_class=5021
cmp P0, P3
cmovl S1, P3
cmovl P3, P0
mov S2, P1
cmovl P0, S1
cmp P2, S2
cmovle P1, P2
cmovle P2, S2
mov S0, P0
cmovl S2, P1
cmp P3, P1
cmovg P1, P3
cmovle S2, P3
cmp S0, P2
