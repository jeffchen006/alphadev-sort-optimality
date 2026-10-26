# n=5 model=out iset=I1 prefix14_class=8564
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P0, P3
cmovg S2, P3
cmovle S2, P0
cmovg P3, P0
mov S1, P3
cmp P2, S1
cmovg S1, P2
cmovg P2, P3
cmp S2, S0
cmovle P3, S2
