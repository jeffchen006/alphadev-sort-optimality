# n=5 model=out iset=I1 prefix14_class=11730
cmp P0, P1
cmovg S1, P0
cmovle S1, P1
cmovle P1, P0
cmp P3, P2
cmovle P0, P3
cmovg P0, P2
cmovge P2, P3
cmovge P3, P0
cmp P2, S1
cmovle S0, P2
cmovle P2, S1
cmovle S1, S0
cmp P1, P0
