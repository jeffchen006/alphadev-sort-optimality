# n=5 model=out iset=I1 prefix14_class=2363
cmp P2, P3
mov S2, P2
cmovge S2, P3
cmovl P2, P3
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovge S1, P0
cmp P2, P1
mov P3, S2
cmovl P0, P1
cmovge P0, P2
cmovle P1, P2
mov S0, P1
