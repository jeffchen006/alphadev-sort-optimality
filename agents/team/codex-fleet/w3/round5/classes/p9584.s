# n=5 model=out iset=I1 prefix14_class=9584
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmovle P3, S2
mov S0, P1
cmp P0, S0
cmovge P1, P0
cmovge P0, S0
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
cmovg P2, P1
cmp P3, P0
cmovle S1, P0
