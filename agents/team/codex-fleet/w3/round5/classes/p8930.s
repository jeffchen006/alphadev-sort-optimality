# n=5 model=out iset=I1 prefix14_class=8930
mov S0, P3
cmp P3, P2
cmovle S0, P2
cmovg P3, P2
cmp P1, P0
cmovge P2, P0
cmovge P0, P1
mov S2, P0
cmovge P1, P2
cmp S0, P0
cmovle P0, S0
cmovle S0, S2
mov S1, P1
cmp P3, P1
