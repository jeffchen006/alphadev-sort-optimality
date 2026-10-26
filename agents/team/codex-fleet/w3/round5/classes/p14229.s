# n=5 model=out iset=I1 prefix14_class=14229
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
mov S2, P0
cmovl P3, S0
cmp P2, P0
cmovle P0, P2
cmovl P2, S2
cmovge S2, P2
mov S1, P0
cmp P3, P2
cmovle P2, P3
cmovg S2, P3
cmovge P3, P2
