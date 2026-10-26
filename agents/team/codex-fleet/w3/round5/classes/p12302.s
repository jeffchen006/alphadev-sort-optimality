# n=5 model=out iset=I1 prefix14_class=12302
mov S1, P2
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmovge P0, S2
mov S0, P0
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmp P0, P1
cmovg P0, P1
cmovle S0, P1
cmp P3, S1
cmovge S2, S1
