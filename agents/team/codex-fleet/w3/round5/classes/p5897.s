# n=5 model=out iset=I1 prefix14_class=5897
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmovge P2, S0
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
mov S2, P3
cmp P1, P3
cmovle S2, P1
mov S1, S2
cmovge P3, P1
cmp P0, P2
