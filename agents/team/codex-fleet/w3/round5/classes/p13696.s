# n=5 model=out iset=I1 prefix14_class=13696
cmp P2, P3
cmovg S1, P2
cmovle S1, P3
cmovge P2, P3
cmp P0, P1
cmovle S0, P0
cmovge S0, P1
cmovle P0, P1
cmp P2, S0
cmovge P3, P2
mov S2, S1
cmovg P2, S0
cmovg S0, P3
cmp P0, S2
