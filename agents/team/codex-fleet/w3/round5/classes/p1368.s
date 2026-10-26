# n=5 model=out iset=I1 prefix14_class=1368
mov S0, P3
mov S2, P2
cmp P0, P2
cmovle S2, P0
cmovg P2, P0
cmp S0, P1
cmovge S0, P1
cmovg P1, P3
cmp P1, P2
cmovle S1, P2
cmovge S1, P1
cmovg P1, P2
cmp S2, S0
cmovg P2, S2
