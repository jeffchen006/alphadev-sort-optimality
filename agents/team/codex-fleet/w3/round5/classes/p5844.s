# n=5 model=out iset=I1 prefix14_class=5844
mov S0, P2
cmp S0, P1
cmovle S0, P1
cmovg P2, P1
cmp P3, P0
cmovle P1, P3
cmovle P3, P0
cmovl P0, P1
cmp P0, P2
mov S1, P0
cmovl S1, P2
mov S2, P3
cmovle P2, P0
cmp P3, S0
