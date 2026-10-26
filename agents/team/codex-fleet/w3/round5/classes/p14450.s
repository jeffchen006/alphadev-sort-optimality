# n=5 model=out iset=I1 prefix14_class=14450
cmp P1, P0
cmovg S2, P0
cmovle S2, P1
cmovg P0, P1
cmp P2, P3
cmovg S0, P3
cmovle S0, P2
cmovle P2, P3
cmp S0, S2
cmovle P1, S0
cmovl S0, S2
mov S1, P0
cmovle S2, P1
cmp S1, P2
