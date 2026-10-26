# n=5 model=out iset=I1 prefix14_class=13244
cmp P2, P1
cmovl S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
cmovle S2, P3
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
mov S1, S2
cmovl P1, S0
cmp S1, P2
