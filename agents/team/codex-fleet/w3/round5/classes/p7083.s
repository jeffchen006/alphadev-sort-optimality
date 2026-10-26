# n=5 model=out iset=I1 prefix14_class=7083
mov S0, P3
cmp P0, S0
cmovge P3, P0
mov S1, P1
cmovg P0, S0
cmp P1, P2
cmovge P1, P2
cmovge P2, S1
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
cmovg P1, P0
cmp P3, P2
cmovle S2, P2
