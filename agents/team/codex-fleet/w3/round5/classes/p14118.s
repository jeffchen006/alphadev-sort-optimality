# n=5 model=out iset=I1 prefix14_class=14118
cmp P3, P0
cmovl S0, P0
cmovle P0, P3
mov S2, P2
cmovl P3, S0
cmp P1, P2
cmovg S2, P1
cmovl P2, P1
mov S1, P0
cmp S2, P3
cmovle S0, S2
cmovle S2, P3
cmovl P3, S0
cmp P2, P0
