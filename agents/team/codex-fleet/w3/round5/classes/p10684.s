# n=5 model=out iset=I1 prefix14_class=10684
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
mov S1, P0
cmovl P3, S2
cmp S1, P1
cmovge P0, P1
cmovl S1, P1
cmp P3, S1
mov S0, S1
cmovl S1, P3
cmovle P3, S0
cmp P0, P2
cmovle P3, P0
