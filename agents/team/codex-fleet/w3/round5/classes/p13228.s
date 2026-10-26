# n=5 model=out iset=I1 prefix14_class=13228
cmp P1, P3
cmovl S0, P3
cmovle P3, P1
cmovl P1, S0
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovg P2, P0
mov S1, P3
cmp S2, S1
cmovl P3, S2
cmovle S2, S1
cmp P2, P1
cmovle P0, P2
