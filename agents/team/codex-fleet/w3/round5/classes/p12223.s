# n=5 model=out iset=I1 prefix14_class=12223
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovl P3, S0
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovle P0, S1
mov S2, P2
cmp P3, S2
cmovl S2, P3
cmovg P2, P3
cmp P0, P1
mov S2, P0
