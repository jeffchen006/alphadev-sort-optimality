# n=5 model=out iset=I1 prefix14_class=1353
mov S0, P0
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
mov S2, P2
cmovle S1, P3
cmp P1, S0
cmovle S0, P1
cmovg P0, P1
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
mov P2, P0
cmp S0, S1
