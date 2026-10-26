# n=5 model=out iset=I1 prefix14_class=2081
cmp P1, P2
cmovg S2, P2
cmovge P2, P1
cmovle S2, P1
cmp P3, P0
cmovge P1, P3
cmovge P3, P0
cmovge P0, P1
cmovl P1, P0
cmp P0, P2
cmovle P0, P2
cmovge P1, P2
cmp P3, S2
cmovge P2, S2
