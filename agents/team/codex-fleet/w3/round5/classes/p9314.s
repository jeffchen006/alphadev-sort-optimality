# n=5 model=out iset=I1 prefix14_class=9314
mov S0, P1
cmp P1, P0
mov S1, P3
cmovle P1, P0
cmovle P0, S0
cmp P2, S1
cmovl S1, P2
cmovle P2, P3
mov S2, P0
cmp S1, S2
cmovle S2, S1
cmovg P0, S1
cmp P1, P2
cmovle S2, P2
