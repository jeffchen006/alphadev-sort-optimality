# n=5 model=out iset=I1 prefix14_class=14161
cmp P1, P3
cmovle S0, P3
mov S2, P0
cmovle P3, P1
cmovle P1, S0
mov S1, P1
cmp P2, S2
cmovge P0, P2
cmovg P2, S2
cmp P1, P0
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
mov S1, P3
