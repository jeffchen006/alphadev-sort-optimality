# n=5 model=out iset=I1 prefix14_class=12917
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovge P3, P1
mov S2, P2
cmp P0, P2
cmovg P2, P0
cmovle S2, P0
cmp S1, S2
cmovge P1, S2
mov S0, P3
cmovge S2, S1
cmovge S1, P1
cmp P2, S0
