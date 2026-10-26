# n=5 model=out iset=I1 prefix14_class=5548
mov S2, P1
cmp P1, P3
cmovl S2, P3
cmovg P1, P3
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovle P0, S0
cmp P0, P1
mov S1, P1
cmovg S1, P0
cmovle P1, P0
cmp S2, P2
cmovle P0, S2
