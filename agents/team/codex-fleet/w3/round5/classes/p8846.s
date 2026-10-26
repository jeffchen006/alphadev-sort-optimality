# n=5 model=out iset=I1 prefix14_class=8846
mov S0, P1
cmp P1, P0
cmovge P1, P0
cmovge P0, S0
cmp P2, P3
cmovg S1, P3
cmovle S1, P2
cmovge P3, P2
mov S2, P3
cmp P0, S2
cmovge P3, P0
cmovle S2, P0
cmp P1, S1
cmovge P2, P1
