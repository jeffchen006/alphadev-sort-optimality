# n=5 model=out iset=I1 prefix14_class=10603
mov S2, P1
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovge P3, S1
cmp P2, S2
cmovle S2, P2
cmovl P2, P1
cmovge P1, P2
cmp P1, P3
cmovle P1, P3
cmovle P3, P2
cmp P0, S2
cmovge S0, S2
