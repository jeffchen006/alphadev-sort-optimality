# n=5 model=out iset=I1 prefix14_class=1355
cmp P3, P2
mov S2, P2
cmovle S2, P3
cmovge P2, P3
mov S1, P2
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P1, P2
cmovge P2, P1
cmovg P1, S1
mov P2, S0
cmp S2, S0
