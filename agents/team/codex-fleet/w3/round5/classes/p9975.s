# n=5 model=out iset=I1 prefix14_class=9975
cmp P3, P2
cmovg S1, P2
cmovle S1, P3
cmovge P2, P3
cmp P1, P0
cmovge P3, P1
cmovge P1, P0
cmovge P0, P3
cmp P2, P0
mov S2, P2
cmovge P2, P0
cmovg P0, S2
mov S0, P1
cmp P1, S1
