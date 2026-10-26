# n=5 model=out iset=I1 prefix14_class=3287
cmp P1, P0
cmovle S2, P0
cmovg S2, P1
cmovg P1, P0
cmp P2, P3
cmovge P0, P3
cmovge P3, P2
cmovge P2, P0
mov S1, P1
mov S0, P3
cmp P1, P2
cmovge P1, P2
cmovg P2, S1
cmovle S1, P2
