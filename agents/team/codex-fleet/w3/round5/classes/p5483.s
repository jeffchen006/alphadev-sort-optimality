# n=5 model=out iset=I1 prefix14_class=5483
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
mov S0, P1
cmovle P3, S1
mov S2, P2
cmp S2, P0
cmovg S2, P0
cmovle P2, P0
cmp P1, S2
cmovl S0, S2
cmovl S2, P1
cmp P2, P3
cmovg P1, P2
