# n=5 model=out iset=I1 prefix14_class=5578
mov S2, P3
mov S1, P0
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmp P0, P2
cmovg P0, P2
cmovle S1, P2
cmp P1, P0
cmovge S0, P0
cmovle S0, P1
cmovge P0, P1
cmp S2, S1
cmovg P3, S2
