# n=5 model=out iset=I1 prefix14_class=14012
mov S1, P0
cmp P0, P3
cmovg S1, P3
cmovge P3, P0
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P2, P3
cmovle S0, P2
cmovg S0, P3
cmovge P3, P2
cmp P1, S1
cmovle P0, S1
