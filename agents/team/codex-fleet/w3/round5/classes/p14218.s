# n=5 model=out iset=I1 prefix14_class=14218
cmp P3, P1
mov S2, P0
cmovle S0, P1
cmovl P1, P3
cmovle P3, S0
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmp P3, S2
cmovle S0, S2
cmovl S2, P3
mov P0, P2
cmovle P3, S0
cmp P0, P1
