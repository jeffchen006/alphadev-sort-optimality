# n=5 model=out iset=I1 prefix14_class=101
mov S2, P1
mov S1, P0
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmp P3, S2
cmovl P1, P3
cmovg S2, P3
cmp P1, P2
cmovge S0, P1
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
cmp P0, S2
