# n=5 model=out iset=I1 prefix14_class=9247
cmp P3, P0
cmovle S0, P3
cmovge S0, P0
cmovge P0, P3
cmp P1, P2
cmovg P3, P1
cmovg P1, P2
cmovg P2, P3
mov S1, P1
cmp S1, S0
cmovle S1, S0
cmovge P1, S0
cmp P0, P2
cmovle S2, P0
