# n=5 model=out iset=I1 prefix14_class=12705
cmp P0, P2
cmovge S1, P2
cmovg P2, P0
cmovg P0, S1
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P1, P0
cmovge S2, P0
cmovge P0, P1
cmovg P1, S2
mov S0, P2
cmp P2, P3
