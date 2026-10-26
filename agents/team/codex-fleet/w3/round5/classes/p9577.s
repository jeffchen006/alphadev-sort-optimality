# n=5 model=out iset=I1 prefix14_class=9577
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
mov S2, P2
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
mov S0, S2
cmp P3, S2
cmovge S2, P3
cmovle S0, P3
cmp P1, P0
cmovle S1, P0
