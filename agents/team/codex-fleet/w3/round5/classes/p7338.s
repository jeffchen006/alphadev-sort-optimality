# n=5 model=out iset=I1 prefix14_class=7338
mov S0, P3
cmp P0, S0
cmovl P3, P0
cmovg S0, P0
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovle P2, S2
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmovl P1, S2
mov S1, S0
cmp S1, P2
