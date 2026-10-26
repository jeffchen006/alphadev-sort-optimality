# n=5 model=out iset=I1 prefix14_class=2397
cmp P3, P2
cmovl S2, P2
cmovge S2, P3
cmovge P3, P2
mov P2, S2
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
cmovl P1, S0
cmp S2, P0
cmovle S2, P0
mov S2, P3
cmovle P0, P2
cmp S2, P1
