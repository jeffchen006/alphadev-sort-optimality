# n=5 model=out iset=I1 prefix14_class=6045
cmp P1, P2
mov S0, P1
cmovle S0, P2
cmovle P2, P1
cmp P0, P3
mov S2, S0
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
cmp P0, S2
cmovg S0, P0
cmovle S2, P0
mov S0, P2
cmp S0, P3
