# n=5 model=out iset=I1 prefix14_class=5877
mov S2, P0
cmp P2, S2
cmovg S2, P2
cmovge P2, P0
cmp P1, P3
cmovle P0, P3
cmovl P3, P1
cmovl P1, P0
cmp P1, S2
cmovge S1, S2
cmovle S1, P1
cmovge S2, P1
cmp P3, P2
cmovle P1, P3
