# n=5 model=out iset=I1 prefix14_class=10553
cmp P1, P2
mov S0, P2
cmovg S0, P1
cmovl P2, P1
cmp P3, P0
cmovle S1, P0
cmovg S1, P3
cmovl P0, P3
cmp S0, S1
cmovle P1, S0
cmovle S0, S1
cmovl S1, P1
cmp P2, P0
mov S2, P2
