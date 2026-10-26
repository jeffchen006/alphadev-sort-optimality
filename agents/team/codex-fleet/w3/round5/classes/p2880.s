# n=5 model=out iset=I1 prefix14_class=2880
mov S1, P0
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
mov S0, P3
cmp S0, P2
cmovl P3, P2
cmovg S0, P2
cmp P3, S1
cmovle S2, S1
cmovl S1, P3
cmovle P3, S2
mov P0, S0
cmp P0, P1
