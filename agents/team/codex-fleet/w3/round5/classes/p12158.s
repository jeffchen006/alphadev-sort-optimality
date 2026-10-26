# n=5 model=out iset=I1 prefix14_class=12158
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
mov S2, P1
cmp P1, P3
cmovge P1, P3
cmovle S2, P3
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
cmovg P0, P3
mov S0, P2
cmp P2, S2
