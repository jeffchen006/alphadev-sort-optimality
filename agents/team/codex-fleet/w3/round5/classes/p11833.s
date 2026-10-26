# n=5 model=out iset=I1 prefix14_class=11833
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
mov S1, P2
mov S2, P0
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmp S1, P0
cmovge P0, S1
cmovle S2, S1
cmp P3, P1
mov S1, S2
