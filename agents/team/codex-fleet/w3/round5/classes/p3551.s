# n=5 model=out iset=I1 prefix14_class=3551
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
mov S2, P3
mov S1, P0
cmp S2, P1
cmovl S2, P1
cmovle P1, P3
cmp P1, S1
cmovl P0, P1
cmovg S1, P1
cmp P2, S2
mov P1, S1
