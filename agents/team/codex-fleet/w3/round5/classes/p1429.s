# n=5 model=out iset=I1 prefix14_class=1429
mov S0, P1
mov S2, P3
cmp P1, P0
cmovge P1, P0
cmovg P0, S0
cmp P2, S2
cmovg P3, P2
cmovge P2, S2
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovge P3, P0
cmp P2, P1
cmovle S1, P1
