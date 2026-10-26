# n=5 model=out iset=I1 prefix14_class=12294
mov S1, P1
cmp P3, S1
cmovle S1, P3
cmovge P1, P3
cmp P0, P2
cmovge S0, P2
mov S2, S1
cmovg P2, P0
cmovge P0, S0
cmp S2, P0
cmovge S1, P0
cmovg P0, S2
mov S1, P2
cmp P2, P1
