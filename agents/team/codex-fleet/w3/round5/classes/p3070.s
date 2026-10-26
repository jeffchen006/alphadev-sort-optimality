# n=5 model=out iset=I1 prefix14_class=3070
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P0, P2
cmovle S1, P0
cmovg S1, P2
cmovle P0, P2
mov S2, P0
cmp P3, S1
cmovg P2, P3
cmovge P3, S1
cmovg S1, P2
cmp P1, S2
