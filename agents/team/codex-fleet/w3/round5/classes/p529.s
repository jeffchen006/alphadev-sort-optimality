# n=5 model=out iset=I1 prefix14_class=529
cmp P3, P1
mov S1, P3
mov S2, P2
cmovg P3, P1
cmovge P1, S1
cmp P2, P0
cmovge P2, P0
cmovge P0, S2
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovg P3, P2
cmp P1, P0
