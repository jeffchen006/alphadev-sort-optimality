# n=5 model=out iset=I1 prefix14_class=4313
mov S1, P3
cmp S1, P0
mov S2, P1
cmovle P3, P0
cmovg S1, P0
mov S0, S1
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
cmp S1, S2
cmovle S1, S2
cmovl S2, S0
cmp P2, P3
cmovle S2, P3
