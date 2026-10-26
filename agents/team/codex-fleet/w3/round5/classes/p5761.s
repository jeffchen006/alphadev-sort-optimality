# n=5 model=out iset=I1 prefix14_class=5761
cmp P1, P2
cmovg S0, P2
mov S1, P3
cmovge P2, P1
cmovg P1, S0
cmp P0, P3
cmovge S1, P0
mov S2, P1
cmovle P3, P0
cmp P3, S2
cmovle S2, P3
cmovg P1, P3
cmp P2, S1
cmovle S0, P2
