# n=5 model=out iset=I1 prefix14_class=9078
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovle P2, S2
cmp P3, P1
cmovle S1, P3
cmovg S1, P1
cmovle P3, P1
cmovle P1, S1
cmp P2, S1
cmovge P1, P2
cmovge P2, S1
cmp P3, P0
cmovge S2, P0
