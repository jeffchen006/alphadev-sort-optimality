# n=5 model=out iset=I1 prefix14_class=12279
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovg P0, P2
cmp P3, P1
cmovge P2, P1
cmovg P1, P3
mov S1, S2
cmovge P3, P2
cmp S1, P3
cmovge S1, P3
cmovg P3, S2
cmp P1, P0
cmovle S0, P0
