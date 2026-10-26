# n=5 model=out iset=I1 prefix14_class=10683
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
mov S1, P0
cmovl P3, S0
cmp P0, P1
cmovg S1, P1
cmovl P0, P1
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
cmp S1, P2
cmovle S2, S1
