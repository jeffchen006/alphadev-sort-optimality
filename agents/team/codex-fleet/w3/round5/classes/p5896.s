# n=5 model=out iset=I1 prefix14_class=5896
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
mov S0, P2
cmovge P3, S2
cmp P1, P2
cmovle P2, P1
mov S2, P0
cmovl P1, S0
cmp P1, P0
cmovge P0, P1
cmovle S2, P1
mov S1, S2
cmp P3, P2
