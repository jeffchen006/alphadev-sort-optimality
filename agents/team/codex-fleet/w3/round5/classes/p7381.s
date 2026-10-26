# n=5 model=out iset=I1 prefix14_class=7381
mov S1, P0
cmp P0, P2
mov S0, P1
cmovle P0, P2
cmovle P2, S1
cmovle S1, P0
cmp S0, P3
cmovge P1, P3
cmovg P3, S0
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovge P1, S2
cmp P3, S1
