# n=5 model=out iset=I1 prefix14_class=6304
mov S2, P0
cmp P3, S2
cmovle S2, P3
cmovge P0, P3
cmp P2, P1
cmovg P3, P2
mov S0, P0
cmovg P2, P1
cmovg P1, P3
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
mov S1, P2
cmp P2, S2
