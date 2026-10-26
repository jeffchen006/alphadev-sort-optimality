# n=5 model=out iset=I1 prefix14_class=3289
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
cmovg P1, P3
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
mov P3, P1
cmp P1, P2
mov S0, P0
cmovge P1, P2
cmovg P2, P3
cmovle P3, P2
