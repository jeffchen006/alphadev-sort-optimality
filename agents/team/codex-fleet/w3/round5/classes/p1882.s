# n=5 model=out iset=I1 prefix14_class=1882
mov S1, P0
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovl P1, P2
cmp P3, P0
mov S2, P1
cmovg S1, P3
cmovl P0, P3
cmp S1, S2
cmovl S2, S1
cmovle S1, P1
cmovle P1, S2
mov S1, P0
