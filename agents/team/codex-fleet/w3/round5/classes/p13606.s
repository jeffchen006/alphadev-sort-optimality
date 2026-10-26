# n=5 model=out iset=I1 prefix14_class=13606
mov S2, P3
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P0, P3
cmovle S2, P0
mov S0, P1
cmovl P0, P3
cmp S2, S0
cmovle S0, S2
cmovl S2, P1
cmovg P1, S2
cmp P0, P2
