# n=5 model=out iset=I1 prefix14_class=7968
cmp P3, P1
mov S0, P1
cmovg P1, P3
mov S1, P0
cmovg P3, S0
cmp S1, P2
cmovg P0, P2
cmovl S1, P2
mov S0, P1
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
cmovle P3, S2
cmp S0, S1
