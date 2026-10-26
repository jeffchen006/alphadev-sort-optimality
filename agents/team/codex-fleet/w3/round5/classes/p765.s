# n=5 model=out iset=I1 prefix14_class=765
mov S1, P1
cmp P0, P1
cmovl S1, P0
mov S2, P2
cmovl P0, P1
cmp S2, P3
cmovg S2, P3
cmovl P2, P3
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovg S0, P2
mov S0, S1
cmp S0, S2
