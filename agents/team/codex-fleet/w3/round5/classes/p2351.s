# n=5 model=out iset=I1 prefix14_class=2351
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
cmovle S1, P0
cmp P3, S1
cmovge P0, S1
cmovg S1, P3
cmovl P0, P3
cmp P1, P2
cmovge S2, P1
