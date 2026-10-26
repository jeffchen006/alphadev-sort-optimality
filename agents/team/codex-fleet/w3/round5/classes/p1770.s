# n=5 model=out iset=I1 prefix14_class=1770
mov S2, P2
cmp P3, P2
mov S1, P1
cmovg P2, P3
cmovg P3, S2
cmp S1, P0
cmovge S1, P0
cmovle P1, P0
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovg P1, P2
cmp S1, P3
cmovge P0, P3
