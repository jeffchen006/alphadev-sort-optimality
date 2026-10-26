# n=5 model=out iset=I1 prefix14_class=3527
mov S0, P0
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovge P1, S2
cmp P0, P3
cmovle P0, P3
mov S1, P1
cmovl P3, S0
cmp P3, S1
cmovle S1, P3
mov S1, P2
cmovge P1, P3
cmp P0, S1
