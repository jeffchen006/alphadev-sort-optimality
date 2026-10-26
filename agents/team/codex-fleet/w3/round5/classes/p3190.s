# n=5 model=out iset=I1 prefix14_class=3190
mov S2, P2
cmp P0, P2
cmovle S2, P0
cmovge P2, P0
cmp P3, P1
mov S0, P3
cmovg P3, P1
cmovg P1, S0
cmp S2, P3
cmovle S1, S2
cmovg S1, P3
cmovle S2, P3
cmp P2, P1
cmovge S0, P1
