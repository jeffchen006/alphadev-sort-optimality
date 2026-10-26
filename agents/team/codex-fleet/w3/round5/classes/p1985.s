# n=5 model=out iset=I1 prefix14_class=1985
mov S2, P3
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovge P1, P0
cmp P2, P3
cmovle S2, P2
cmovl P2, P3
mov P3, P2
cmp P3, S1
cmovle P3, S1
cmovl S1, P2
cmp P1, S2
cmovl S0, P1
