# n=5 model=out iset=I1 prefix14_class=6070
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovg S2, P2
mov S0, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, S0
mov S1, P1
cmp S2, S1
cmovle P1, S2
cmovg S1, S2
cmp P0, P3
cmovl S1, P3
