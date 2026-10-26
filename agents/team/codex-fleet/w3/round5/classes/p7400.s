# n=5 model=out iset=I1 prefix14_class=7400
cmp P1, P3
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
cmp P2, P0
cmovge S2, P2
mov S1, P3
cmovg P2, P0
cmovge P0, S2
cmp P2, S1
cmovg P3, P2
cmovg P2, S1
cmp P1, P0
cmovle S2, P0
