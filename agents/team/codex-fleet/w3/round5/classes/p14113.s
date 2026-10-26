# n=5 model=out iset=I1 prefix14_class=14113
cmp P2, P1
mov S1, P1
cmovle S1, P2
cmovl P2, P1
mov S2, P0
cmp P3, S2
cmovge P0, P3
cmovl S2, P3
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovl P2, P1
mov S0, S1
cmp S2, S1
