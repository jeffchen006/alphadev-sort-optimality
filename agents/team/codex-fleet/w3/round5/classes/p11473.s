# n=5 model=out iset=I1 prefix14_class=11473
cmp P1, P3
mov S2, P0
mov S0, P1
cmovle P1, P3
cmovle P3, S0
cmp S2, P2
cmovle S2, P2
cmovle P2, P0
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
mov P3, P1
cmovl P2, S1
cmp S2, P3
