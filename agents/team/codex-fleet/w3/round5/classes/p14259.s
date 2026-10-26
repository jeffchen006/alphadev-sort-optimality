# n=5 model=out iset=I1 prefix14_class=14259
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovg P1, S0
cmp P3, P0
cmovg S2, P0
cmovg P0, P3
cmovg P3, S2
mov S2, P2
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmp P1, P3
cmovle S0, P3
