# n=5 model=out iset=I1 prefix14_class=6261
mov S2, P0
cmp P1, P0
mov S0, P2
cmovl P0, P1
cmovle P1, S2
mov S1, P1
cmp P3, P2
cmovle P2, P3
cmovg S0, P3
cmp S0, P1
cmovl S1, S0
cmovle S0, P1
cmp P2, P0
cmovg S2, P2
