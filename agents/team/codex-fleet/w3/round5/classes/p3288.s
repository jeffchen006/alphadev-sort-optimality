# n=5 model=out iset=I1 prefix14_class=3288
cmp P1, P3
cmovle S2, P3
cmovg S2, P1
cmovg P1, P3
cmp P2, P0
cmovge P3, P0
cmovge P0, P2
cmovge P2, P3
mov S1, P1
mov S0, P0
cmp P1, P2
cmovge P1, P2
cmovg P2, S1
cmovle S1, P2
