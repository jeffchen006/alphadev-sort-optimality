# n=5 model=out iset=I1 prefix14_class=11271
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, P1
cmovle S2, P1
mov S0, P2
cmovge S2, P3
cmovle P1, P3
cmp P2, S2
cmovl P2, S2
cmovg S0, S2
cmp P1, P0
cmovge P3, P1
