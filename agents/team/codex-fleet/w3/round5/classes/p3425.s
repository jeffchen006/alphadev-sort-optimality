# n=5 model=out iset=I1 prefix14_class=3425
cmp P3, P2
mov S1, P2
cmovle S1, P3
cmovg P2, P3
mov S2, P0
cmp P1, S2
cmovge P0, P1
cmovge P1, S2
cmp P1, S1
mov S0, P1
cmovle S0, S1
cmovle S1, P1
cmp P2, P0
cmovge S2, P0
