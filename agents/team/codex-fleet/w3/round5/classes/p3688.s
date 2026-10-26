# n=5 model=out iset=I1 prefix14_class=3688
mov S1, P0
cmp S1, P2
cmovle S1, P2
cmovle P2, P0
mov S0, P2
cmp P1, P3
cmovl S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P2, P3
cmovle P2, P3
cmovle P3, S0
mov S0, P1
cmp S1, S0
