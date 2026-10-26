# n=5 model=out iset=I1 prefix14_class=10153
cmp P0, P3
cmovle S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
cmovle P0, P1
cmovl P1, P2
cmovge P0, P2
cmp P1, S1
cmovge S0, S1
cmovg S1, P1
cmovge P1, S0
cmp P3, P0
cmovge S0, P0
