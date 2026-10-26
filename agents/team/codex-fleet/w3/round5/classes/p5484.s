# n=5 model=out iset=I1 prefix14_class=5484
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
mov S2, P1
cmovle P3, S1
mov S0, P2
cmp S0, P0
cmovle P2, P0
cmovg S0, P0
cmp P1, S0
cmovl S2, S0
cmovl S0, P1
cmp P2, P3
mov P1, P2
