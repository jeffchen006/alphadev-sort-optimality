# n=5 model=out iset=I1 prefix14_class=3090
cmp P2, P3
cmovle S1, P3
cmovge S1, P2
mov S2, P0
cmovge P2, P3
cmp P1, S2
cmovle P0, P1
cmovl P1, S2
mov P3, P0
cmp P0, P2
cmovl P0, P2
cmovge P3, P2
cmp P1, S1
cmovge S0, P1
