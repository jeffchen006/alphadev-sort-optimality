# n=5 model=out iset=I1 prefix14_class=1805
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
mov S2, P1
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
cmovg S0, P0
cmp P2, P1
