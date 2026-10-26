# n=5 model=out iset=I1 prefix14_class=5387
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
mov S0, P3
cmovle P1, S1
cmp P3, P2
cmovge P3, P2
cmovl S0, P2
cmp P0, P3
cmovge P2, P3
cmovl P2, P0
cmovge P3, P0
mov S2, S0
cmp P1, S0
