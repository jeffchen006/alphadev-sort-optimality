# n=5 model=out iset=I1 prefix14_class=5667
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
mov S2, P2
cmovl P3, S0
mov S1, P0
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmp P3, S1
mov S2, P3
