# n=5 model=out iset=I1 prefix14_class=11798
cmp P1, P2
cmovl S1, P2
cmovl P2, P1
mov S2, P0
cmovl P1, S1
cmp P0, P3
cmovle S2, P3
cmovge P0, P3
mov S0, S2
cmp P1, S0
cmovge S2, P1
cmovge P1, S0
cmp P2, P0
cmovle P3, P2
