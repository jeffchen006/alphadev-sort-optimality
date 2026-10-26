# n=5 model=out iset=I1 prefix14_class=1557
mov S1, P2
cmp P3, S1
cmovge S1, P3
cmovge P3, P2
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovle S0, P1
mov S2, P3
cmp S2, P0
cmovge P3, P0
cmovg P0, S2
cmp S1, S0
cmovge S2, S0
