# n=5 model=out iset=I1 prefix14_class=8587
mov S0, P2
cmp P3, P0
cmovle S2, P3
cmovge S2, P0
cmovl P3, P0
cmp P2, P1
cmovge S0, P1
mov P0, S2
cmovge P1, P2
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P0, S0
