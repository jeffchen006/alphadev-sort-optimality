# n=5 model=out iset=I1 prefix14_class=14008
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovg S1, P1
cmp P0, P3
cmovl S0, P0
cmovle P0, P3
mov P1, P2
cmovl P3, S0
cmp S1, P0
cmovle S0, S1
cmovl S1, P0
cmovl P0, S0
cmp P3, P2
