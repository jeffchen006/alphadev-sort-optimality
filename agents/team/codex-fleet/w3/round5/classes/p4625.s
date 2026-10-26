# n=5 model=out iset=I1 prefix14_class=4625
mov S1, P3
cmp P1, P3
cmovle P3, P1
cmovge S1, P1
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P2, S1
cmovge P1, P2
cmovl P1, S1
cmovge P2, S1
cmp P0, P3
cmovle S2, P3
