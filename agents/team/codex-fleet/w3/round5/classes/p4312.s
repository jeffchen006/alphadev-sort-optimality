# n=5 model=out iset=I1 prefix14_class=4312
cmp P3, P0
mov S1, P3
mov S0, P2
cmovge P3, P0
cmovl S1, P0
cmp P2, P1
cmovle S0, P1
mov S2, P3
cmovge P2, P1
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
cmp S1, S0
cmovle P2, S0
