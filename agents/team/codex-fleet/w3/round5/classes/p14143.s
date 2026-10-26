# n=5 model=out iset=I1 prefix14_class=14143
mov S2, P1
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovle P3, S1
cmp P2, P1
cmovg P1, P2
cmovge P2, S2
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmovle S0, P1
mov P3, P0
cmp P3, P2
