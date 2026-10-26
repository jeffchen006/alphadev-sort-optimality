# n=5 model=out iset=I1 prefix14_class=6258
cmp P0, P3
cmovle S1, P3
mov S0, P2
cmovl P3, P0
cmovge S1, P0
cmp P1, P2
cmovge P2, P1
cmovl S0, P1
cmp P2, S1
mov P0, S0
cmovle S2, S1
cmovle S1, P2
cmovle P2, S2
cmp P0, P3
