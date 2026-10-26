# n=5 model=out iset=I1 prefix14_class=2882
cmp P2, P1
cmovle S2, P2
mov S0, P0
cmovl P2, P1
mov S1, P2
cmovl P1, S2
cmp P0, P3
cmovl P0, P3
cmovg S0, P3
cmp P0, S1
cmovl P2, P0
cmovle P0, S1
cmovl S1, P2
cmp S0, P1
