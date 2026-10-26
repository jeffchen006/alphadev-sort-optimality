# n=5 model=out iset=I1 prefix14_class=4626
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovge S1, P0
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P2, S1
cmovge P0, P2
cmovl P0, S1
cmovge P2, S1
cmp P1, P3
cmovle S2, P3
