# n=5 model=out iset=I1 prefix14_class=12110
mov S1, P0
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmovle P3, P0
cmp P3, S1
cmovg S2, P3
cmovge P3, S1
cmovle S2, S1
cmp P1, P2
cmovge S0, P1
