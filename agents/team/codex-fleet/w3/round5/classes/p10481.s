# n=5 model=out iset=I1 prefix14_class=10481
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
mov S2, P2
cmp P0, P2
cmovg P2, P0
mov S0, P1
cmovl S2, P0
cmp P2, P3
cmovl P0, P3
cmovle P3, P2
cmovl P2, P0
cmp S2, S0
