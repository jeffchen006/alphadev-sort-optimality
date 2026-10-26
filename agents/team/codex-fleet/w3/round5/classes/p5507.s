# n=5 model=out iset=I1 prefix14_class=5507
cmp P2, P3
mov S0, P2
mov S2, P0
cmovl P2, P3
cmovl P3, S0
cmp P0, P1
cmovg P0, P1
cmovle S2, P1
mov S1, P3
cmp S1, P0
cmovl S1, P0
cmovle P0, P3
cmp S2, P2
cmovl P0, S2
