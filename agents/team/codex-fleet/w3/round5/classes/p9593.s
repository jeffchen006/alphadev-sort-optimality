# n=5 model=out iset=I1 prefix14_class=9593
cmp P2, P3
mov S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P1, P0
cmovge S1, P0
mov S0, S2
cmovge P0, P1
cmovge P1, S1
cmp S0, P0
cmovge S0, P0
cmovg P0, S2
cmp P3, P1
cmovle S2, P1
